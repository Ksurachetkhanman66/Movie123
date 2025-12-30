import { useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '@/hooks/useAuth';
import { Button } from '@/components/ui/button';
import { Loader2, LogOut } from 'lucide-react';

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
          <h1 className="text-xl font-bold text-foreground">หน้าหลัก</h1>
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
        <div className="text-center max-w-2xl mx-auto">
          <h2 className="text-3xl font-bold text-foreground mb-4">
            ยินดีต้อนรับ! 🎉
          </h2>
          <p className="text-muted-foreground mb-8">
            คุณได้เข้าสู่ระบบเรียบร้อยแล้ว เริ่มต้นสร้างแอปพลิเคชันของคุณได้เลย
          </p>
          <div className="bg-card border border-border rounded-lg p-6 text-left">
            <h3 className="font-semibold text-foreground mb-2">ข้อมูลผู้ใช้</h3>
            <p className="text-sm text-muted-foreground">
              <strong>อีเมล:</strong> {user.email}
            </p>
            <p className="text-sm text-muted-foreground">
              <strong>User ID:</strong> {user.id}
            </p>
          </div>
        </div>
      </main>
    </div>
  );
};

export default Index;
