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
    const id = url.searchParams.get('id');
    const section = url.searchParams.get('section');
    const category = url.searchParams.get('category');
    const featured = url.searchParams.get('featured');
    const limit = url.searchParams.get('limit');

    if (req.method === 'GET') {
      let query = supabaseClient.from('dramas').select('*');

      // Filter by specific ID
      if (id) {
        const { data, error } = await query.eq('id', id).maybeSingle();
        
        if (error) {
          console.error('Error fetching drama by id:', error);
          throw error;
        }
        
        if (!data) {
          return new Response(
            JSON.stringify({ success: false, error: 'Drama not found' }),
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

      // Filter by section
      if (section) {
        query = query.eq('section', section);
      }

      // Filter by featured
      if (featured === 'true') {
        query = query.eq('is_featured', true);
      }

      // Filter by category
      if (category) {
        query = query.contains('category', [category]);
      }

      // Apply limit
      if (limit) {
        query = query.limit(parseInt(limit));
      }

      // Order by view_count descending
      query = query.order('view_count', { ascending: false });

      const { data, error } = await query;

      if (error) {
        console.error('Error fetching dramas:', error);
        throw error;
      }

      console.log(`Fetched ${data?.length || 0} dramas`);

      return new Response(
        JSON.stringify({ success: true, data, total: data?.length || 0 }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
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
