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
    const supabaseClient = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_ANON_KEY') ?? ''
    );

    const url = new URL(req.url);
    const dramaId = url.searchParams.get('drama_id');
    const episodeId = url.searchParams.get('id');

    // For POST requests, get params from body
    let bodyParams: Record<string, string> = {};
    if (req.method === 'POST') {
      try {
        bodyParams = await req.json();
      } catch {
        bodyParams = {};
      }
    }

    const finalDramaId = dramaId || bodyParams.drama_id;
    const finalEpisodeId = episodeId || bodyParams.id;

    if (req.method === 'GET' || req.method === 'POST') {
      // Get single episode by ID
      if (finalEpisodeId) {
        const { data, error } = await supabaseClient
          .from('episodes')
          .select('*')
          .eq('id', finalEpisodeId)
          .maybeSingle();
        
        if (error) {
          console.error('Error fetching episode:', error);
          throw error;
        }
        
        if (!data) {
          return new Response(
            JSON.stringify({ success: false, error: 'Episode not found' }),
            { 
              status: 404,
              headers: { ...corsHeaders, 'Content-Type': 'application/json' }
            }
          );
        }
        
        return new Response(
          JSON.stringify({ success: true, data }),
          { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
        );
      }

      // Get all episodes for a drama
      if (finalDramaId) {
        const { data, error } = await supabaseClient
          .from('episodes')
          .select('*')
          .eq('drama_id', finalDramaId)
          .order('episode_number', { ascending: true });
        
        if (error) {
          console.error('Error fetching episodes:', error);
          throw error;
        }

        console.log(`Fetched ${data?.length || 0} episodes for drama ${finalDramaId}`);
        
        return new Response(
          JSON.stringify({ success: true, data, total: data?.length || 0 }),
          { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
        );
      }

      return new Response(
        JSON.stringify({ success: false, error: 'drama_id is required' }),
        { 
          status: 400,
          headers: { ...corsHeaders, 'Content-Type': 'application/json' }
        }
      );
    }

    return new Response(
      JSON.stringify({ success: false, error: 'Method not allowed' }),
      { 
        status: 405,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' }
      }
    );

  } catch (error: unknown) {
    const errorMessage = error instanceof Error ? error.message : 'Unknown error occurred';
    console.error('Edge function error:', errorMessage);
    return new Response(
      JSON.stringify({ success: false, error: errorMessage }),
      { 
        status: 500,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' }
      }
    );
  }
});
