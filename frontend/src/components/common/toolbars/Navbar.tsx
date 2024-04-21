import { AppBar, SvgIcon, Toolbar, Typography } from '@mui/material';
import { GiMusicSpell } from "react-icons/gi";
import DarkModeButton from '../buttons/DarkModeButton.tsx';

function Navbar() {
  return (
    <AppBar position="fixed" enableColorOnDark sx={{zIndex: (theme) => theme.zIndex.drawer + 1}}>
      <Toolbar>
        <SvgIcon children={<GiMusicSpell />} sx={{display: {xs: 'none', md: 'flex'}, mr: 1}} />
        <Typography variant="h6" noWrap component="div" sx={{fontFamily: 'Oswald Variable, sans-serif', flexGrow: 1}}>
          Ossia Archive
        </Typography>
        <DarkModeButton/>
      </Toolbar>
    </AppBar>
  )
}

export default Navbar
