import React from 'react'
import ReactDOM from 'react-dom/client'
import App from './App.tsx'
import { BrowserRouter } from "react-router-dom";
import ThemeProvider from './theme/ThemeProvider.tsx';
import './index.css'

// Import fonts
import '@fontsource-variable/oswald';
import '@fontsource-variable/archivo'

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <ThemeProvider>
      <BrowserRouter>
        <App />
      </BrowserRouter>
    </ThemeProvider>
  </React.StrictMode>,
)
