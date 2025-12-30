import { useState, useEffect, useRef } from 'react';
import { useParams, Link } from 'react-router-dom';
import { 
  Play, 
  Star, 
  ChevronLeft, 
  Lock, 
  Clock, 
  Eye,
  Share2,
  Heart,
  Maximize,
  Volume2,
  Pause,
  SkipBack,
  SkipForward
} from 'lucide-react';
import { supabase } from '@/integrations/supabase/client';
import { useAuth } from '@/hooks/useAuth';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
import { Skeleton } from '@/components/ui/skeleton';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { ScrollArea } from '@/components/ui/scroll-area';
import { useToast } from '@/hooks/use-toast';

interface Drama {
  id: string;
  title: string;
  title_en: string | null;
  poster_url: string;
  description: string | null;
  episodes: number;
  category: string[];
  section: string;
  view_count: number;
  rating: number;
  year: number | null;
  is_featured: boolean;
}

interface Episode {
  id: string;
  drama_id: string;
  episode_number: number;
  title: string;
  description: string | null;
  thumbnail_url: string | null;
  video_url: string | null;
  duration: number;
  is_free: boolean;
  view_count: number;
}

const DramaDetail = () => {
  const { id } = useParams<{ id: string }>();
  const { user } = useAuth();
  const { toast } = useToast();
  const videoRef = useRef<HTMLVideoElement>(null);
  
  const [drama, setDrama] = useState<Drama | null>(null);
  const [episodes, setEpisodes] = useState<Episode[]>([]);
  const [currentEpisode, setCurrentEpisode] = useState<Episode | null>(null);
  const [loading, setLoading] = useState(true);
  const [isPlaying, setIsPlaying] = useState(false);
  const [isFavorite, setIsFavorite] = useState(false);
  const [favoriteLoading, setFavoriteLoading] = useState(false);

  useEffect(() => {
    if (id) {
      fetchDramaDetails();
    }
  }, [id]);

  useEffect(() => {
    const checkFavorite = async () => {
      if (id && user) {
        // Ensure we have a valid session before calling
        const { data: { session } } = await supabase.auth.getSession();
        if (session?.access_token) {
          try {
            const { data, error } = await supabase.functions.invoke('favorites', {
              body: { action: 'CHECK', drama_id: id }
            });
            
            if (!error && data) {
              setIsFavorite(data?.isFavorite || false);
            }
          } catch (err) {
            console.error('Error checking favorite status:', err);
          }
        }
      } else {
        setIsFavorite(false);
      }
    };
    
    checkFavorite();
  }, [id, user]);

  const toggleFavorite = async () => {
    if (!user) {
      toast({
        title: "กรุณาเข้าสู่ระบบ",
        description: "ต้องเข้าสู่ระบบก่อนเพิ่มรายการโปรด",
        variant: "destructive"
      });
      return;
    }

    setFavoriteLoading(true);
    try {
      if (isFavorite) {
        // Remove from favorites
        const { error } = await supabase.functions.invoke('favorites', {
          body: { action: 'REMOVE', drama_id: id }
        });
        
        if (!error) {
          setIsFavorite(false);
          toast({ title: "ลบออกจากรายการโปรดแล้ว" });
        }
      } else {
        // Add to favorites
        const { error } = await supabase.functions.invoke('favorites', {
          body: { action: 'ADD', drama_id: id }
        });
        
        if (!error) {
          setIsFavorite(true);
          toast({ title: "เพิ่มในรายการโปรดแล้ว" });
        }
      }
    } catch (err) {
      console.error('Error toggling favorite:', err);
      toast({
        title: "เกิดข้อผิดพลาด",
        description: "ไม่สามารถดำเนินการได้",
        variant: "destructive"
      });
    } finally {
      setFavoriteLoading(false);
    }
  };

  const fetchDramaDetails = async () => {
    try {
      setLoading(true);
      
      // Fetch drama details
      const { data: dramaData, error: dramaError } = await supabase.functions.invoke('dramas', {
        body: { id }
      });
      
      if (dramaError) throw dramaError;
      
      if (dramaData?.data) {
        setDrama(dramaData.data);
      }

      // Fetch episodes
      const { data: episodesData, error: episodesError } = await supabase.functions.invoke('episodes', {
        body: { drama_id: id }
      });
      
      if (episodesError) throw episodesError;
      
      if (episodesData?.data) {
        setEpisodes(episodesData.data);
        // Set first episode as current
        if (episodesData.data.length > 0) {
          setCurrentEpisode(episodesData.data[0]);
        }
      }
      
    } catch (err) {
      console.error('Error fetching drama details:', err);
    } finally {
      setLoading(false);
    }
  };

  const handleEpisodeSelect = (episode: Episode) => {
    if (!episode.is_free && !user) {
      // Show login prompt for locked episodes
      return;
    }
    setCurrentEpisode(episode);
    setIsPlaying(false);
    // Scroll to video player
    window.scrollTo({ top: 0, behavior: 'smooth' });
  };

  const handlePlayPause = () => {
    if (videoRef.current) {
      if (isPlaying) {
        videoRef.current.pause();
      } else {
        videoRef.current.play();
      }
      setIsPlaying(!isPlaying);
    }
  };

  const handleNextEpisode = () => {
    if (currentEpisode && episodes.length > 0) {
      const currentIndex = episodes.findIndex(ep => ep.id === currentEpisode.id);
      if (currentIndex < episodes.length - 1) {
        handleEpisodeSelect(episodes[currentIndex + 1]);
      }
    }
  };

  const handlePrevEpisode = () => {
    if (currentEpisode && episodes.length > 0) {
      const currentIndex = episodes.findIndex(ep => ep.id === currentEpisode.id);
      if (currentIndex > 0) {
        handleEpisodeSelect(episodes[currentIndex - 1]);
      }
    }
  };

  const formatDuration = (minutes: number) => {
    return `${minutes} นาที`;
  };

  const formatViewCount = (count: number) => {
    if (count >= 1000000) {
      return `${(count / 1000000).toFixed(1)}M`;
    }
    if (count >= 1000) {
      return `${(count / 1000).toFixed(1)}K`;
    }
    return count.toString();
  };

  if (loading) {
    return (
      <div className="min-h-screen bg-background">
        <div className="container mx-auto px-4 py-8">
          <Skeleton className="aspect-video w-full rounded-xl mb-6" />
          <Skeleton className="h-8 w-1/2 mb-4" />
          <Skeleton className="h-4 w-full mb-2" />
          <Skeleton className="h-4 w-3/4" />
        </div>
      </div>
    );
  }

  if (!drama) {
    return (
      <div className="min-h-screen bg-background flex items-center justify-center">
        <div className="text-center">
          <h1 className="text-2xl font-bold text-foreground mb-4">ไม่พบละครเรื่องนี้</h1>
          <Link to="/">
            <Button>กลับหน้าหลัก</Button>
          </Link>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-background">
      {/* Header */}
      <header className="sticky top-0 z-50 bg-background/95 backdrop-blur-md border-b border-border">
        <div className="container mx-auto px-4 py-3">
          <div className="flex items-center gap-4">
            <Link to="/">
              <Button variant="ghost" size="icon">
                <ChevronLeft className="h-5 w-5" />
              </Button>
            </Link>
            <div className="flex items-center gap-2">
              <div className="bg-gradient-to-r from-red-500 to-pink-500 rounded-lg p-2">
                <Play className="h-4 w-4 text-white fill-white" />
              </div>
              <span className="text-lg font-bold bg-gradient-to-r from-red-500 to-pink-500 bg-clip-text text-transparent">
                MovieForU
              </span>
            </div>
          </div>
        </div>
      </header>

      <main className="container mx-auto px-4 py-6">
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
          {/* Video Player Section */}
          <div className="lg:col-span-2">
            {/* Video Player */}
            <div className="relative aspect-video bg-black rounded-xl overflow-hidden mb-4">
              {currentEpisode?.video_url ? (
                <>
                  <video
                    ref={videoRef}
                    src={currentEpisode.video_url}
                    className="w-full h-full object-contain"
                    poster={currentEpisode.thumbnail_url || drama.poster_url}
                    onPlay={() => setIsPlaying(true)}
                    onPause={() => setIsPlaying(false)}
                    controls
                  />
                  {/* Custom Controls Overlay */}
                  <div className="absolute bottom-0 left-0 right-0 bg-gradient-to-t from-black/80 to-transparent p-4 opacity-0 hover:opacity-100 transition-opacity">
                    <div className="flex items-center justify-between">
                      <div className="flex items-center gap-4">
                        <Button 
                          variant="ghost" 
                          size="icon" 
                          className="text-white hover:bg-white/20"
                          onClick={handlePrevEpisode}
                        >
                          <SkipBack className="h-5 w-5" />
                        </Button>
                        <Button 
                          variant="ghost" 
                          size="icon" 
                          className="text-white hover:bg-white/20"
                          onClick={handlePlayPause}
                        >
                          {isPlaying ? (
                            <Pause className="h-6 w-6 fill-white" />
                          ) : (
                            <Play className="h-6 w-6 fill-white" />
                          )}
                        </Button>
                        <Button 
                          variant="ghost" 
                          size="icon" 
                          className="text-white hover:bg-white/20"
                          onClick={handleNextEpisode}
                        >
                          <SkipForward className="h-5 w-5" />
                        </Button>
                        <Button variant="ghost" size="icon" className="text-white hover:bg-white/20">
                          <Volume2 className="h-5 w-5" />
                        </Button>
                      </div>
                      <Button variant="ghost" size="icon" className="text-white hover:bg-white/20">
                        <Maximize className="h-5 w-5" />
                      </Button>
                    </div>
                  </div>
                </>
              ) : (
                <div className="w-full h-full flex items-center justify-center">
                  <p className="text-white/60">ไม่มีวิดีโอ</p>
                </div>
              )}
            </div>

            {/* Episode Info */}
            {currentEpisode && (
              <div className="mb-6">
                <h2 className="text-xl font-bold text-foreground mb-2">
                  {currentEpisode.title}
                </h2>
                <p className="text-muted-foreground text-sm">
                  {currentEpisode.description}
                </p>
              </div>
            )}

            {/* Drama Info */}
            <div className="bg-muted/30 rounded-xl p-6 mb-6">
              <div className="flex gap-6">
                <img
                  src={drama.poster_url}
                  alt={drama.title}
                  className="w-24 h-36 object-cover rounded-lg hidden md:block"
                />
                <div className="flex-1">
                  <h1 className="text-2xl font-bold text-foreground mb-2">{drama.title}</h1>
                  {drama.title_en && (
                    <p className="text-muted-foreground mb-3">{drama.title_en}</p>
                  )}
                  <div className="flex flex-wrap items-center gap-4 mb-4">
                    <div className="flex items-center gap-1">
                      <Star className="h-4 w-4 fill-yellow-400 text-yellow-400" />
                      <span className="font-medium">{drama.rating}</span>
                    </div>
                    <div className="flex items-center gap-1 text-muted-foreground">
                      <Eye className="h-4 w-4" />
                      <span>{formatViewCount(drama.view_count)} ครั้ง</span>
                    </div>
                    <Badge variant="outline">{drama.episodes} ตอน</Badge>
                    {drama.year && <Badge variant="secondary">{drama.year}</Badge>}
                  </div>
                  <div className="flex flex-wrap gap-2 mb-4">
                    {drama.category.map((cat, idx) => (
                      <Badge key={idx} variant="outline">
                        {cat}
                      </Badge>
                    ))}
                  </div>
                  <p className="text-muted-foreground text-sm line-clamp-3">
                    {drama.description}
                  </p>
                </div>
              </div>
              
              {/* Action Buttons */}
              <div className="flex gap-3 mt-6">
                <Button 
                  variant="outline" 
                  className="flex-1"
                  onClick={toggleFavorite}
                  disabled={favoriteLoading}
                >
                  <Heart className={`h-4 w-4 mr-2 ${isFavorite ? 'fill-red-500 text-red-500' : ''}`} />
                  {isFavorite ? 'ถูกใจแล้ว' : 'ถูกใจ'}
                </Button>
                <Button variant="outline" className="flex-1">
                  <Share2 className="h-4 w-4 mr-2" />
                  แชร์
                </Button>
              </div>
            </div>
          </div>

          {/* Episodes List */}
          <div className="lg:col-span-1">
            <Tabs defaultValue="episodes" className="w-full">
              <TabsList className="w-full">
                <TabsTrigger value="episodes" className="flex-1">รายการตอน</TabsTrigger>
                <TabsTrigger value="related" className="flex-1">เรื่องที่คล้ายกัน</TabsTrigger>
              </TabsList>
              
              <TabsContent value="episodes" className="mt-4">
                <ScrollArea className="h-[600px] pr-4">
                  <div className="space-y-3">
                    {episodes.map((episode) => (
                      <div
                        key={episode.id}
                        onClick={() => handleEpisodeSelect(episode)}
                        className={`flex gap-3 p-3 rounded-lg cursor-pointer transition-all ${
                          currentEpisode?.id === episode.id
                            ? 'bg-primary/10 border border-primary/30'
                            : 'bg-muted/50 hover:bg-muted'
                        }`}
                      >
                        <div className="relative w-28 h-16 flex-shrink-0">
                          <img
                            src={episode.thumbnail_url || drama.poster_url}
                            alt={episode.title}
                            className="w-full h-full object-cover rounded-md"
                          />
                          {!episode.is_free && !user && (
                            <div className="absolute inset-0 bg-black/60 flex items-center justify-center rounded-md">
                              <Lock className="h-4 w-4 text-white" />
                            </div>
                          )}
                          {currentEpisode?.id === episode.id && (
                            <div className="absolute inset-0 bg-primary/40 flex items-center justify-center rounded-md">
                              <Play className="h-5 w-5 text-white fill-white" />
                            </div>
                          )}
                        </div>
                        <div className="flex-1 min-w-0">
                          <h4 className="font-medium text-foreground text-sm line-clamp-1">
                            {episode.title}
                          </h4>
                          <div className="flex items-center gap-2 text-xs text-muted-foreground mt-1">
                            <div className="flex items-center gap-1">
                              <Clock className="h-3 w-3" />
                              <span>{formatDuration(episode.duration)}</span>
                            </div>
                            <div className="flex items-center gap-1">
                              <Eye className="h-3 w-3" />
                              <span>{formatViewCount(episode.view_count)}</span>
                            </div>
                          </div>
                          <div className="flex items-center gap-2 mt-1">
                            {episode.is_free ? (
                              <Badge variant="secondary" className="text-xs py-0">
                                ฟรี
                              </Badge>
                            ) : (
                              <Badge variant="outline" className="text-xs py-0">
                                <Lock className="h-2.5 w-2.5 mr-1" />
                                VIP
                              </Badge>
                            )}
                          </div>
                        </div>
                      </div>
                    ))}
                  </div>
                </ScrollArea>
              </TabsContent>
              
              <TabsContent value="related" className="mt-4">
                <div className="text-center py-8 text-muted-foreground">
                  ยังไม่มีเรื่องที่คล้ายกัน
                </div>
              </TabsContent>
            </Tabs>
          </div>
        </div>
      </main>
    </div>
  );
};

export default DramaDetail;
