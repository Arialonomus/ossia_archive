// Define global font settings
export const typography = {
  typography: {
    fontFamily: 'Archivo Variable, sans-serif'
  }
}

// Define color overrides
const colors = {
  primary: {
    main: '#c2720a'
  },
  secondary: {
    main: '#0a5ac2'
  },
  error: {
    main: '#c2160a'
  },
  warning: {
    main: '#b6c20a'
  },
  info: {
    main: '#0ac272'
  },
  success: {
    main: '#5ac20a'
  }
};

// Build a new palette object for the theme based on the passed in mode
export const palette = (mode: 'light' | 'dark') => ({
  palette: {
    mode,
    ...colors
  }
})