// Define global font settings
export const typography = {
  typography: {
    fontFamily: 'Archivo Variable, sans-serif'
  }
}

// Define color overrides for the accent colors
const colors = {
  primary: {
    main: '#dc8522'
  },
  secondary: {
    main: '#2279dc'
  }
};

// Build a new palette object for the theme based on the passed ib mode
export const palette = (mode: 'light' | 'dark') => ({
  palette: {
    ...colors,
    mode
  }
})