// Deletes the calling user's account and, via ON DELETE CASCADE, every row
// they own (phases.md Phase 3). The service-role key exists only here, as
// the platform-provided SUPABASE_SERVICE_ROLE_KEY secret; it never ships in
// the app.
import { createClient } from "jsr:@supabase/supabase-js@2";

const json = (status: number, body: unknown) =>
  new Response(JSON.stringify(body), {
    status,
    headers: { "Content-Type": "application/json" },
  });

Deno.serve(async (req) => {
  if (req.method !== "POST") return json(405, { error: "method_not_allowed" });

  const jwt = req.headers.get("Authorization")?.replace(/^Bearer\s+/i, "");
  if (!jwt) return json(401, { error: "missing_token" });

  const url = Deno.env.get("SUPABASE_URL")!;
  const serviceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
  const admin = createClient(url, serviceKey, {
    auth: { autoRefreshToken: false, persistSession: false },
  });

  // Who is asking? Verified from their own token, never from the body.
  const { data, error } = await admin.auth.getUser(jwt);
  if (error || !data.user) return json(401, { error: "invalid_token" });

  const { error: deleteError } = await admin.auth.admin.deleteUser(data.user.id);
  if (deleteError) {
    // No user details in logs (CLAUDE.md rule 7).
    console.error("delete failed", deleteError.status);
    return json(500, { error: "delete_failed" });
  }
  return json(200, { deleted: true });
});
