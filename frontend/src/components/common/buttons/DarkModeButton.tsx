import { useContext } from 'react';
import { DarkModeContext } from '../../../contexts/DarkModeContext.tsx';
import { IconButton, useTheme } from '@mui/material';
import DarkModeOutlinedIcon from '@mui/icons-material/DarkModeOutlined';
import DarkModeIcon from '@mui/icons-material/DarkMode';

function DarkModeButton() {
  const { toggleDarkMode } = useContext(DarkModeContext);
  const theme = useTheme();

  return (
    <IconButton onClick={toggleDarkMode} color='inherit'>
      {theme.palette.mode === 'dark' ? <DarkModeIcon /> : <DarkModeOutlinedIcon/>}
    </IconButton>
  )
}

export default DarkModeButton
