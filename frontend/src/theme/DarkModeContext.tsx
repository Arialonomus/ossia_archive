import {createContext, useContext} from 'react';

export const DarkModeContext = createContext({
  toggleDarkMode: () => {},
  mode: 'light'
})

export const useDarkModeContext = () => useContext(DarkModeContext)