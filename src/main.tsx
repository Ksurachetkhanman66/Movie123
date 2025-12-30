import { createRoot } from "react-dom/client";
import "./index.css";

// Use MySQL backend when VITE_API_URL is set, otherwise use Supabase
const useMySQL = !!import.meta.env.VITE_API_URL;

async function initApp() {
  const root = createRoot(document.getElementById("root")!);
  
  if (useMySQL) {
    const { default: AppMySQL } = await import("./AppMySQL.tsx");
    root.render(<AppMySQL />);
  } else {
    const { default: App } = await import("./App.tsx");
    root.render(<App />);
  }
}

initApp();
