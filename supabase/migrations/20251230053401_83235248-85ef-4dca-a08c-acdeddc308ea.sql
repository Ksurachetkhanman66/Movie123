-- Create dramas table for Chinese drama/movie website
CREATE TABLE public.dramas (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  title TEXT NOT NULL,
  title_en TEXT,
  poster_url TEXT NOT NULL,
  description TEXT,
  episodes INTEGER DEFAULT 1,
  category TEXT[] DEFAULT '{}',
  section TEXT DEFAULT 'general',
  view_count INTEGER DEFAULT 0,
  rating NUMERIC(3,1) DEFAULT 0,
  year INTEGER,
  is_featured BOOLEAN DEFAULT false,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Enable Row Level Security
ALTER TABLE public.dramas ENABLE ROW LEVEL SECURITY;

-- Create policy for public read access
CREATE POLICY "Anyone can view dramas" 
ON public.dramas 
FOR SELECT 
USING (true);

-- Create policy for authenticated users to manage dramas
CREATE POLICY "Authenticated users can insert dramas" 
ON public.dramas 
FOR INSERT 
WITH CHECK (auth.uid() IS NOT NULL);

CREATE POLICY "Authenticated users can update dramas" 
ON public.dramas 
FOR UPDATE 
USING (auth.uid() IS NOT NULL);

CREATE POLICY "Authenticated users can delete dramas" 
ON public.dramas 
FOR DELETE 
USING (auth.uid() IS NOT NULL);

-- Create trigger for automatic timestamp updates
CREATE TRIGGER update_dramas_updated_at
BEFORE UPDATE ON public.dramas
FOR EACH ROW
EXECUTE FUNCTION public.update_updated_at_column();

-- Create index for better query performance
CREATE INDEX idx_dramas_section ON public.dramas(section);
CREATE INDEX idx_dramas_is_featured ON public.dramas(is_featured);
CREATE INDEX idx_dramas_category ON public.dramas USING GIN(category);