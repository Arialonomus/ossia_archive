import React, { useState } from 'react'
import { palette, typography } from './theme.ts';
import { createTheme, useMediaQuery } from '@mui/material';
import { ThemeProvider as MUIThemeProvider } from '@mui/material/styles';
import { DarkModeContext } from './DarkModeContext.tsx';

interface ThemeProviderProps {
  children: React.ReactNode
}

function ThemeProvider({ children }: ThemeProviderProps) {
  const prefersDarkMode = useMediaQuery('(prefers-color-scheme: dark)');
  const [mode, setMode] = useState<'light' | 'dark'>(prefersDarkMode ? 'dark' : 'light');
  const theme = createTheme({
    ...typography,
    ...palette(mode)
  })

  const toggleDarkMode = () => {
    setMode((prevMode) => (prevMode === 'light' ? 'dark' : 'light'))
  }

  return (
    <DarkModeContext.Provider value={{ toggleDarkMode, mode }}>
      <MUIThemeProvider theme={theme}>
        {children}
      </MUIThemeProvider>
    </DarkModeContext.Provider>
  )
}

export default ThemeProvider
