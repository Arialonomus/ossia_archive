import React, { useEffect, useMemo, useState } from 'react'
import { palette, typography } from './theme.ts';
import { createTheme, useMediaQuery } from '@mui/material';
import { ThemeProvider as MUIThemeProvider } from '@mui/material/styles';
import { DarkModeContext } from '../contexts/DarkModeContext.tsx';

interface ThemeProviderProps {
  children: React.ReactNode
}

function ThemeProvider({ children }: ThemeProviderProps) {
  // Query the browser state to see if dark mode is set at the system level
  const prefersDarkMode = useMediaQuery('(prefers-color-scheme: dark)');

  // Initialization of state with either local storage or system preference
  const [mode, setMode] = useState<'light' | 'dark'>(
    localStorage.getItem('themeMode')
      ? localStorage.getItem('themeMode') as 'light' | 'dark'
      : prefersDarkMode ? 'dark' : 'light'
  );

  // Update local storage whenever the mode changes
  useEffect(() => {
    localStorage.setItem('themeMode', mode);
  }, [mode]);

  // Create a theme instance dynamically based on the current mode
  const theme = useMemo(() => createTheme({
    ...typography,
    ...palette(mode)
  }), [mode])

  // Function for toggling dark mode in components
  const toggleDarkMode = () => {
    setMode((prevMode) => (prevMode === 'light' ? 'dark' : 'light'))
  }

  return (
    <DarkModeContext.Provider value={{ toggleDarkMode }}>
      <MUIThemeProvider theme={theme}>
        {children}
      </MUIThemeProvider>
    </DarkModeContext.Provider>
  )
}

export default ThemeProvider
