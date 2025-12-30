import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
};

serve(async (req: Request) => {
  // Handle CORS preflight requests
  if (req.method === 'OPTIONS') {
    return new Response(null, { headers: corsHeaders });
  }

  try {
    // Get auth header for user authentication
    const authHeader = req.headers.get('Authorization');
    if (!authHeader) {
      return new Response(
        JSON.stringify({ success: false, error: 'Missing authorization header' }),
        { status: 401, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    }

    const supabaseClient = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_ANON_KEY') ?? '',
      { global: { headers: { Authorization: authHeader } } }
    );

    // Get user from auth
    const { data: { user }, error: userError } = await supabaseClient.auth.getUser();
    if (userError || !user) {
      console.error('Auth error:', userError);
      return new Response(
        JSON.stringify({ success: false, error: 'Unauthorized' }),
        { status: 401, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    }

    const url = new URL(req.url);

    // GET - Fetch user's favorites with drama details
    if (req.method === 'GET') {
      const dramaId = url.searchParams.get('drama_id');

      // Check if specific drama is favorited
      if (dramaId) {
        const { data, error } = await supabaseClient
          .from('favorites')
          .select('id')
          .eq('user_id', user.id)
          .eq('drama_id', dramaId)
          .maybeSingle();

        if (error) throw error;

        return new Response(
          JSON.stringify({ success: true, isFavorite: !!data }),
          { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
        );
      }

      // Get all favorites with drama details
      const { data, error } = await supabaseClient
        .from('favorites')
        .select('id, drama_id, created_at, dramas(*)')
        .eq('user_id', user.id)
        .order('created_at', { ascending: false });

      if (error) throw error;

      console.log(`Fetched ${data?.length || 0} favorites for user ${user.id}`);

      return new Response(
        JSON.stringify({ success: true, data, total: data?.length || 0 }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    }

    // POST - Add to favorites
    if (req.method === 'POST') {
      const body = await req.json();
      const dramaId = body.drama_id;

      if (!dramaId) {
        return new Response(
          JSON.stringify({ success: false, error: 'drama_id is required' }),
          { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
        );
      }

      const { data, error } = await supabaseClient
        .from('favorites')
        .insert({ user_id: user.id, drama_id: dramaId })
        .select()
        .single();

      if (error) {
        // Handle duplicate error
        if (error.code === '23505') {
          return new Response(
            JSON.stringify({ success: false, error: 'Already in favorites' }),
            { status: 409, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
          );
        }
        throw error;
      }

      console.log(`Added favorite ${data.id} for user ${user.id}`);

      return new Response(
        JSON.stringify({ success: true, data }),
        { status: 201, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    }

    // DELETE - Remove from favorites
    if (req.method === 'DELETE') {
      const dramaId = url.searchParams.get('drama_id');

      if (!dramaId) {
        return new Response(
          JSON.stringify({ success: false, error: 'drama_id is required' }),
          { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
        );
      }

      const { error } = await supabaseClient
        .from('favorites')
        .delete()
        .eq('user_id', user.id)
        .eq('drama_id', dramaId);

      if (error) throw error;

      console.log(`Removed favorite for drama ${dramaId} for user ${user.id}`);

      return new Response(
        JSON.stringify({ success: true }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    }

    return new Response(
      JSON.stringify({ success: false, error: 'Method not allowed' }),
      { status: 405, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    );

  } catch (error: unknown) {
    const errorMessage = error instanceof Error ? error.message : 'Unknown error occurred';
    console.error('Edge function error:', errorMessage);
    return new Response(
      JSON.stringify({ success: false, error: errorMessage }),
      { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    );
  }
});
