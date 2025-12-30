import { useState, useEffect, useCallback } from 'react';
import { Link } from 'react-router-dom';
import { Search, Play, Star, ChevronRight, User, Menu, X, Heart, ChevronLeft } from 'lucide-react';
import { dramasApi, Drama } from '@/services/api';
import { useAuth } from '@/hooks/useAuthMySQL';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Badge } from '@/components/ui/badge';
import { Skeleton } from '@/components/ui/skeleton';

const CATEGORIES = ['โรแมนติก', 'ดราม่า', 'แอคชั่น', 'ย้อนยุค', 'แฟนตาซี'];

const Home = () => {
  const { user, signOut } = useAuth();
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedCategory, setSelectedCategory] = useState<string | null>(null);
  const [allDramas, setAllDramas] = useState<Drama[]>([]);
  const [featuredDramas, setFeaturedDramas] = useState<Drama[]>([]);
  const [trendingDramas, setTrendingDramas] = useState<Drama[]>([]);
  const [mustSeeDramas, setMustSeeDramas] = useState<Drama[]>([]);
  const [hiddenGemsDramas, setHiddenGemsDramas] = useState<Drama[]>([]);
  const [loading, setLoading] = useState(true);
  const [activeFeatured, setActiveFeatured] = useState(0);
  const [isAutoPlaying, setIsAutoPlaying] = useState(true);
  const [slideDirection, setSlideDirection] = useState<'left' | 'right'>('right');

  // Auto-advance carousel
  useEffect(() => {
    if (!isAutoPlaying || featuredDramas.length <= 1) return;
    
    const interval = setInterval(() => {
      setSlideDirection('right');
      setActiveFeatured(prev => (prev + 1) % featuredDramas.length);
    }, 5000);
    
    return () => clearInterval(interval);
  }, [isAutoPlaying, featuredDramas.length]);

  const goToSlide = useCallback((index: number) => {
    setSlideDirection(index > activeFeatured ? 'right' : 'left');
    setActiveFeatured(index);
    setIsAutoPlaying(false);
    setTimeout(() => setIsAutoPlaying(true), 10000);
  }, [activeFeatured]);

  const goToPrevious = useCallback(() => {
    setSlideDirection('left');
    setActiveFeatured(prev => (prev - 1 + featuredDramas.length) % featuredDramas.length);
    setIsAutoPlaying(false);
    setTimeout(() => setIsAutoPlaying(true), 10000);
  }, [featuredDramas.length]);

  const goToNext = useCallback(() => {
    setSlideDirection('right');
    setActiveFeatured(prev => (prev + 1) % featuredDramas.length);
    setIsAutoPlaying(false);
    setTimeout(() => setIsAutoPlaying(true), 10000);
  }, [featuredDramas.length]);

  useEffect(() => {
    fetchDramas();
  }, []);

  const fetchDramas = async () => {
    try {
      setLoading(true);
      
      // Fetch all dramas from REST API
      const response = await dramasApi.getAll();
      
      if (!response.success) throw new Error(response.error);
      
      const dramas: Drama[] = response.data || [];
      setAllDramas(dramas);
      
      // Categorize dramas
      setFeaturedDramas(dramas.filter(d => d.is_featured).slice(0, 3));
      setTrendingDramas(dramas.filter(d => d.section === 'trending').slice(0, 6));
      setMustSeeDramas(dramas.filter(d => d.section === 'must-see').slice(0, 6));
      setHiddenGemsDramas(dramas.filter(d => d.section === 'hidden-gems').slice(0, 6));
      
    } catch (err) {
      console.error('Error fetching dramas:', err);
    } finally {
      setLoading(false);
    }
  };

  // Filter dramas based on search and category
  const filteredDramas = allDramas.filter(drama => {
    const matchesSearch = searchQuery.trim() === '' || 
      drama.title.toLowerCase().includes(searchQuery.toLowerCase()) ||
      (drama.title_en && drama.title_en.toLowerCase().includes(searchQuery.toLowerCase()));
    
    const matchesCategory = !selectedCategory || 
      (drama.category && drama.category.includes(selectedCategory));
    
    return matchesSearch && matchesCategory;
  });

  const isSearching = searchQuery.trim() !== '' || selectedCategory !== null;

  const handleSignOut = async () => {
    await signOut();
  };

  const DramaCard = ({ drama }: { drama: Drama }) => (
    <Link to={`/drama/${drama.id}`} className="group cursor-pointer transition-all duration-300 hover:scale-105 block">
      <div className="relative aspect-[2/3] overflow-hidden rounded-lg">
        <img
          src={drama.poster_url}
          alt={drama.title}
          className="h-full w-full object-cover transition-transform duration-300 group-hover:scale-110"
        />
        <div className="absolute inset-0 bg-gradient-to-t from-black/80 via-transparent to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300" />
        <div className="absolute bottom-2 left-2 right-2">
          <Badge variant="secondary" className="bg-primary/90 text-primary-foreground text-xs">
            {drama.episodes} ตอน
          </Badge>
        </div>
        <div className="absolute top-2 right-2 opacity-0 group-hover:opacity-100 transition-opacity">
          <div className="bg-black/60 backdrop-blur-sm rounded-full p-2">
            <Play className="h-4 w-4 text-white fill-white" />
          </div>
        </div>
      </div>
      <div className="mt-3 space-y-1">
        <h3 className="font-semibold text-sm text-foreground line-clamp-1 group-hover:text-primary transition-colors">
          {drama.title}
        </h3>
        <div className="flex items-center gap-1 text-xs text-muted-foreground">
          <Star className="h-3 w-3 fill-yellow-400 text-yellow-400" />
          <span>{drama.rating}</span>
        </div>
        <div className="flex flex-wrap gap-1">
          {drama.category.slice(0, 2).map((cat, idx) => (
            <Badge key={idx} variant="outline" className="text-xs py-0 px-1.5">
              {cat}
            </Badge>
          ))}
        </div>
      </div>
    </Link>
  );

  const SectionHeader = ({ title, showMore = true }: { title: string; showMore?: boolean }) => (
    <div className="flex items-center justify-between mb-6">
      <h2 className="text-xl md:text-2xl font-bold text-foreground">{title}</h2>
      {showMore && (
        <Button variant="ghost" size="sm" className="text-primary hover:text-primary/80">
          เพิ่มเติม <ChevronRight className="h-4 w-4 ml-1" />
        </Button>
      )}
    </div>
  );

  const SkeletonCard = () => (
    <div className="space-y-3">
      <Skeleton className="aspect-[2/3] rounded-lg" />
      <Skeleton className="h-4 w-3/4" />
      <Skeleton className="h-3 w-1/2" />
    </div>
  );

  return (
    <div className="min-h-screen bg-background">
      {/* Header */}
      <header className="sticky top-0 z-50 bg-background/95 backdrop-blur-md border-b border-border">
        <div className="container mx-auto px-4 py-3">
          <div className="flex items-center justify-between gap-4">
            {/* Logo */}
            <Link to="/" className="flex items-center gap-1">
              <span className="text-2xl font-extrabold bg-gradient-to-r from-amber-500 via-yellow-400 to-orange-500 bg-clip-text text-transparent tracking-tight">
                Movie
              </span>
              <span className="text-2xl font-extrabold text-foreground tracking-tight">
                For
              </span>
              <span className="text-2xl font-extrabold bg-gradient-to-r from-orange-500 to-amber-500 bg-clip-text text-transparent tracking-tight">
                U
              </span>
            </Link>

            {/* Navigation */}
            <nav className="hidden md:flex items-center gap-6">
              <Link to="/" className="text-foreground font-medium hover:text-primary transition-colors">
                หน้าแรก
              </Link>
              <Link to="/favorites" className="text-muted-foreground hover:text-primary transition-colors flex items-center gap-1">
                <Heart className="h-4 w-4" />
                รายการโปรด
              </Link>
            </nav>

            {/* Search */}
            <div className="hidden md:flex flex-1 max-w-md">
              <div className="relative w-full">
                <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
                <Input
                  type="text"
                  placeholder="ค้นหาละคร..."
                  value={searchQuery}
                  onChange={(e) => setSearchQuery(e.target.value)}
                  className="pl-10 bg-muted/50 border-0 focus-visible:ring-primary"
                />
              </div>
            </div>

            {/* User Actions */}
            <div className="flex items-center gap-2">
              {user ? (
                <Button variant="ghost" size="sm" onClick={handleSignOut} className="hidden md:flex">
                  <User className="h-4 w-4 mr-2" />
                  ออกจากระบบ
                </Button>
              ) : (
                <Link to="/auth">
                  <Button variant="default" size="sm" className="bg-gradient-to-r from-amber-500 to-orange-500 hover:from-amber-600 hover:to-orange-600">
                    เข้าสู่ระบบ
                  </Button>
                </Link>
              )}
              <Button variant="ghost" size="icon" className="md:hidden">
                <Menu className="h-5 w-5" />
              </Button>
            </div>
          </div>
        </div>
      </header>

      <main className="container mx-auto px-4 py-8">
        {/* Category Filter */}
        <section className="mb-6">
          <div className="flex flex-wrap items-center gap-2">
            <Button
              variant={selectedCategory === null ? "default" : "outline"}
              size="sm"
              onClick={() => setSelectedCategory(null)}
              className={selectedCategory === null ? "bg-gradient-to-r from-amber-500 to-orange-500 hover:from-amber-600 hover:to-orange-600" : ""}
            >
              ทั้งหมด
            </Button>
            {CATEGORIES.map(category => (
              <Button
                key={category}
                variant={selectedCategory === category ? "default" : "outline"}
                size="sm"
                onClick={() => setSelectedCategory(selectedCategory === category ? null : category)}
                className={selectedCategory === category ? "bg-gradient-to-r from-amber-500 to-orange-500 hover:from-amber-600 hover:to-orange-600" : ""}
              >
                {category}
              </Button>
            ))}
          </div>
        </section>

        {/* Search Results or Home Content */}
        {isSearching ? (
          <section className="mb-12">
            <div className="flex items-center justify-between mb-6">
              <div className="flex items-center gap-3">
                <h2 className="text-xl md:text-2xl font-bold text-foreground">
                  ผลการค้นหา
                </h2>
                <Badge variant="secondary" className="text-sm">
                  {filteredDramas.length} เรื่อง
                </Badge>
              </div>
              <Button
                variant="ghost"
                size="sm"
                onClick={() => {
                  setSearchQuery('');
                  setSelectedCategory(null);
                }}
                className="text-muted-foreground hover:text-foreground"
              >
                <X className="h-4 w-4 mr-1" />
                ล้างการค้นหา
              </Button>
            </div>

            {filteredDramas.length === 0 ? (
              <div className="text-center py-16">
                <div className="text-6xl mb-4">🔍</div>
                <h3 className="text-xl font-semibold text-foreground mb-2">ไม่พบละครที่ค้นหา</h3>
                <p className="text-muted-foreground">ลองค้นหาด้วยคำอื่น หรือเลือกหมวดหมู่อื่น</p>
              </div>
            ) : (
              <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-6 gap-4">
                {filteredDramas.map(drama => (
                  <DramaCard key={drama.id} drama={drama} />
                ))}
              </div>
            )}
          </section>
        ) : (
          <>
        {/* Hero / Featured Section */}
        {!loading && featuredDramas.length > 0 && (
          <section className="mb-12">
            <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
              {/* Main Featured Carousel */}
              <div 
                className="lg:col-span-2 relative group cursor-pointer overflow-hidden rounded-2xl"
                onMouseEnter={() => setIsAutoPlaying(false)}
                onMouseLeave={() => setIsAutoPlaying(true)}
              >
                {/* Carousel Container */}
                <div className="relative aspect-[16/9] lg:aspect-[21/9]">
                  {featuredDramas.map((drama, idx) => (
                    <div
                      key={drama.id}
                      className={`absolute inset-0 transition-all duration-700 ease-in-out ${
                        idx === activeFeatured 
                          ? 'opacity-100 scale-100 z-10' 
                          : 'opacity-0 scale-105 z-0'
                      }`}
                    >
                      <img
                        src={drama.poster_url}
                        alt={drama.title}
                        className="h-full w-full object-cover"
                      />
                    </div>
                  ))}
                </div>

                {/* Gradient Overlay */}
                <div className="absolute inset-0 bg-gradient-to-t from-black via-black/40 to-transparent z-20" />
                
                {/* Content */}
                <div className="absolute bottom-0 left-0 right-0 p-6 md:p-8 z-30">
                  <div className="animate-fade-in" key={activeFeatured}>
                    <Badge className="bg-amber-500 text-white mb-3 animate-scale-in">
                      แนะนำ
                    </Badge>
                    <h1 className="text-2xl md:text-4xl font-bold text-white mb-2">
                      {featuredDramas[activeFeatured]?.title}
                    </h1>
                    <p className="text-white/80 text-sm md:text-base mb-4 line-clamp-2 max-w-xl">
                      {featuredDramas[activeFeatured]?.description}
                    </p>
                    <div className="flex items-center gap-4">
                      <Link to={`/drama/${featuredDramas[activeFeatured]?.id}`}>
                        <Button className="bg-gradient-to-r from-amber-500 to-orange-500 hover:from-amber-600 hover:to-orange-600 transition-all duration-300 hover:scale-105">
                          <Play className="h-4 w-4 mr-2 fill-white" />
                          ดูเลย
                        </Button>
                      </Link>
                      <div className="flex items-center gap-2 text-white/80">
                        <Star className="h-4 w-4 fill-yellow-400 text-yellow-400" />
                        <span>{featuredDramas[activeFeatured]?.rating}</span>
                        <span className="mx-2">•</span>
                        <span>{featuredDramas[activeFeatured]?.episodes} ตอน</span>
                      </div>
                    </div>
                  </div>
                </div>

                {/* Navigation Arrows */}
                <button
                  onClick={goToPrevious}
                  className="absolute left-4 top-1/2 -translate-y-1/2 z-30 bg-black/50 hover:bg-black/70 text-white p-2 rounded-full opacity-0 group-hover:opacity-100 transition-all duration-300 hover:scale-110"
                  aria-label="Previous slide"
                >
                  <ChevronLeft className="h-6 w-6" />
                </button>
                <button
                  onClick={goToNext}
                  className="absolute right-4 top-1/2 -translate-y-1/2 z-30 bg-black/50 hover:bg-black/70 text-white p-2 rounded-full opacity-0 group-hover:opacity-100 transition-all duration-300 hover:scale-110"
                  aria-label="Next slide"
                >
                  <ChevronRight className="h-6 w-6" />
                </button>

                {/* Progress Dots with Timer */}
                <div className="absolute bottom-4 right-4 flex gap-2 z-30">
                  {featuredDramas.map((_, idx) => (
                    <button
                      key={idx}
                      onClick={() => goToSlide(idx)}
                      className="relative h-2 overflow-hidden rounded-full transition-all duration-300"
                      style={{ width: idx === activeFeatured ? '24px' : '8px' }}
                      aria-label={`Go to slide ${idx + 1}`}
                    >
                      <span className={`absolute inset-0 ${idx === activeFeatured ? 'bg-white/50' : 'bg-white/30'}`} />
                      {idx === activeFeatured && isAutoPlaying && (
                        <span 
                          className="absolute inset-0 bg-white origin-left"
                          style={{
                            animation: 'progress 5s linear forwards'
                          }}
                        />
                      )}
                      {idx === activeFeatured && !isAutoPlaying && (
                        <span className="absolute inset-0 bg-white" />
                      )}
                    </button>
                  ))}
                </div>
              </div>

              {/* Side Featured Cards */}
              <div className="space-y-4">
                {featuredDramas.slice(0, 2).map((drama, idx) => (
                  <Link 
                    key={drama.id} 
                    to={`/drama/${drama.id}`}
                    className={`block relative overflow-hidden rounded-xl group cursor-pointer transition-all duration-300 hover:scale-[1.02] ${
                      idx === activeFeatured ? 'ring-2 ring-primary' : ''
                    }`}
                    onClick={() => goToSlide(idx)}
                  >
                    <div className="aspect-[16/9]">
                      <img
                        src={drama.poster_url}
                        alt={drama.title}
                        className="h-full w-full object-cover transition-transform duration-300 group-hover:scale-105"
                      />
                    </div>
                    <div className="absolute inset-0 bg-gradient-to-t from-black/80 to-transparent" />
                    <div className="absolute bottom-3 left-3 right-3">
                      <h3 className="text-white font-semibold text-sm line-clamp-1">{drama.title}</h3>
                      <div className="flex items-center gap-2 text-white/70 text-xs mt-1">
                        <Star className="h-3 w-3 fill-yellow-400 text-yellow-400" />
                        <span>{drama.rating}</span>
                      </div>
                    </div>
                  </Link>
                ))}
              </div>
            </div>
          </section>
        )}

        {/* Trending Section */}
        <section className="mb-12">
          <SectionHeader title="🔥 กำลังฮิต" />
          <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-6 gap-4">
            {loading ? (
              Array(6).fill(0).map((_, idx) => <SkeletonCard key={idx} />)
            ) : trendingDramas.length > 0 ? (
              trendingDramas.map(drama => <DramaCard key={drama.id} drama={drama} />)
            ) : (
              allDramas.slice(0, 6).map(drama => <DramaCard key={drama.id} drama={drama} />)
            )}
          </div>
        </section>

        {/* Must See Section */}
        <section className="mb-12">
          <SectionHeader title="⭐ ต้องดู" />
          <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-6 gap-4">
            {loading ? (
              Array(6).fill(0).map((_, idx) => <SkeletonCard key={idx} />)
            ) : mustSeeDramas.length > 0 ? (
              mustSeeDramas.map(drama => <DramaCard key={drama.id} drama={drama} />)
            ) : (
              allDramas.slice(6, 12).map(drama => <DramaCard key={drama.id} drama={drama} />)
            )}
          </div>
        </section>

        {/* Hidden Gems Section */}
        <section className="mb-12">
          <SectionHeader title="💎 อัญมณีซ่อนเร้น" />
          <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-6 gap-4">
            {loading ? (
              Array(6).fill(0).map((_, idx) => <SkeletonCard key={idx} />)
            ) : hiddenGemsDramas.length > 0 ? (
              hiddenGemsDramas.map(drama => <DramaCard key={drama.id} drama={drama} />)
            ) : (
              allDramas.slice(12, 18).map(drama => <DramaCard key={drama.id} drama={drama} />)
            )}
          </div>
        </section>

        {/* All Dramas Section */}
        <section className="mb-12">
          <SectionHeader title="📺 ละครทั้งหมด" showMore={false} />
          <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-6 gap-4">
            {loading ? (
              Array(12).fill(0).map((_, idx) => <SkeletonCard key={idx} />)
            ) : (
              allDramas.slice(0, 24).map(drama => <DramaCard key={drama.id} drama={drama} />)
            )}
          </div>
        </section>
          </>
        )}
      </main>

      {/* Footer */}
      <footer className="bg-muted/50 border-t border-border py-8">
        <div className="container mx-auto px-4">
          <div className="flex flex-col md:flex-row items-center justify-between gap-4">
            <div className="flex items-center gap-2">
              <div className="bg-gradient-to-r from-amber-500 to-orange-500 rounded-lg p-2">
                <Play className="h-4 w-4 text-white fill-white" />
              </div>
              <span className="font-bold bg-gradient-to-r from-amber-500 to-orange-500 bg-clip-text text-transparent">
                MovieForU
              </span>
            </div>
            <p className="text-sm text-muted-foreground">
              © 2024 MovieForU. สงวนลิขสิทธิ์ทั้งหมด
            </p>
          </div>
        </div>
      </footer>

      {/* Add keyframes for progress animation */}
      <style>{`
        @keyframes progress {
          from { transform: scaleX(0); }
          to { transform: scaleX(1); }
        }
        @keyframes fade-in {
          from { opacity: 0; transform: translateY(10px); }
          to { opacity: 1; transform: translateY(0); }
        }
        @keyframes scale-in {
          from { transform: scale(0.9); opacity: 0; }
          to { transform: scale(1); opacity: 1; }
        }
        .animate-fade-in {
          animation: fade-in 0.5s ease-out;
        }
        .animate-scale-in {
          animation: scale-in 0.3s ease-out;
        }
      `}</style>
    </div>
  );
};

export default Home;
