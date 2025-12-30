-- Create episodes table for drama episodes
CREATE TABLE public.episodes (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  drama_id UUID NOT NULL REFERENCES public.dramas(id) ON DELETE CASCADE,
  episode_number INTEGER NOT NULL,
  title TEXT NOT NULL,
  description TEXT,
  thumbnail_url TEXT,
  video_url TEXT,
  duration INTEGER DEFAULT 0,
  is_free BOOLEAN DEFAULT false,
  view_count INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  UNIQUE(drama_id, episode_number)
);

-- Enable Row Level Security
ALTER TABLE public.episodes ENABLE ROW LEVEL SECURITY;

-- Create policy for public read access
CREATE POLICY "Anyone can view episodes" 
ON public.episodes 
FOR SELECT 
USING (true);

-- Create policy for authenticated users to manage episodes
CREATE POLICY "Authenticated users can insert episodes" 
ON public.episodes 
FOR INSERT 
WITH CHECK (auth.uid() IS NOT NULL);

CREATE POLICY "Authenticated users can update episodes" 
ON public.episodes 
FOR UPDATE 
USING (auth.uid() IS NOT NULL);

CREATE POLICY "Authenticated users can delete episodes" 
ON public.episodes 
FOR DELETE 
USING (auth.uid() IS NOT NULL);

-- Create trigger for automatic timestamp updates
CREATE TRIGGER update_episodes_updated_at
BEFORE UPDATE ON public.episodes
FOR EACH ROW
EXECUTE FUNCTION public.update_updated_at_column();

-- Create indexes for better query performance
CREATE INDEX idx_episodes_drama_id ON public.episodes(drama_id);
CREATE INDEX idx_episodes_episode_number ON public.episodes(episode_number);