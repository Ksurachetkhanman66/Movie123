import { useEffect } from 'react';
import { useNavigate, Link } from 'react-router-dom';
import { useAuth } from '@/hooks/useAuth';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Loader2, LogOut, Package, Database, Code } from 'lucide-react';

const Index = () => {
  const { user, loading, signOut } = useAuth();
  const navigate = useNavigate();

  useEffect(() => {
    if (!loading && !user) {
      navigate('/auth');
    }
  }, [user, loading, navigate]);

  const handleSignOut = async () => {
    await signOut();
    navigate('/auth');
  };

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-background">
        <Loader2 className="h-8 w-8 animate-spin text-primary" />
      </div>
    );
  }

  if (!user) {
    return null;
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-background via-secondary/20 to-background">
      <header className="border-b border-border/50 bg-background/80 backdrop-blur-sm">
        <div className="container mx-auto px-4 py-4 flex items-center justify-between">
          <h1 className="text-xl font-bold text-foreground">Full-Stack Web App</h1>
          <div className="flex items-center gap-4">
            <span className="text-sm text-muted-foreground hidden sm:block">
              {user.email}
            </span>
            <Button variant="outline" size="sm" onClick={handleSignOut}>
              <LogOut className="h-4 w-4 mr-2" />
              ออกจากระบบ
            </Button>
          </div>
        </div>
      </header>

      <main className="container mx-auto px-4 py-12">
        <div className="text-center max-w-3xl mx-auto mb-12">
          <h2 className="text-3xl font-bold text-foreground mb-4">
            ยินดีต้อนรับสู่ Full-Stack Web App 🚀
          </h2>
          <p className="text-muted-foreground">
            แอปพลิเคชันนี้ประกอบด้วย Frontend (React), Backend API (Edge Functions) และ Database (PostgreSQL)
          </p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-12">
          <Card className="hover:shadow-lg transition-shadow">
            <CardHeader>
              <Database className="h-8 w-8 text-primary mb-2" />
              <CardTitle>Database</CardTitle>
              <CardDescription>
                PostgreSQL พร้อมตาราง items และข้อมูลตัวอย่าง 10 รายการ
              </CardDescription>
            </CardHeader>
          </Card>
          
          <Card className="hover:shadow-lg transition-shadow">
            <CardHeader>
              <Code className="h-8 w-8 text-primary mb-2" />
              <CardTitle>Backend API</CardTitle>
              <CardDescription>
                Edge Function สำหรับ API endpoint /items รองรับ GET requests
              </CardDescription>
            </CardHeader>
          </Card>
          
          <Card className="hover:shadow-lg transition-shadow">
            <CardHeader>
              <Package className="h-8 w-8 text-primary mb-2" />
              <CardTitle>Frontend</CardTitle>
              <CardDescription>
                React + TypeScript พร้อม UI สำหรับแสดงรายการสินค้า
              </CardDescription>
            </CardHeader>
          </Card>
        </div>

        <div className="text-center">
          <Link to="/items">
            <Button size="lg" className="gap-2">
              <Package className="h-5 w-5" />
              ดูรายการสินค้า
            </Button>
          </Link>
        </div>

        <Card className="mt-12 max-w-2xl mx-auto">
          <CardHeader>
            <CardTitle>ข้อมูลผู้ใช้</CardTitle>
          </CardHeader>
          <CardContent>
            <p className="text-sm text-muted-foreground">
              <strong>อีเมล:</strong> {user.email}
            </p>
            <p className="text-sm text-muted-foreground">
              <strong>User ID:</strong> {user.id}
            </p>
          </CardContent>
        </Card>
      </main>
    </div>
  );
};

export default Index;
