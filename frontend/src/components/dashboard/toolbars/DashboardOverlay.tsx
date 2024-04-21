import React from 'react'
import { Box, CssBaseline, SvgIcon } from '@mui/material';
import Navbar from '../../common/toolbars/Navbar.tsx'
import DashboardSidebar from './DashboardSidebar.tsx';
import { ListItemLinkProps } from '../../common/list/ListItemLink.tsx';

// Import icons
import HomeRoundedIcon from '@mui/icons-material/HomeRounded';
import { GiMusicalScore, GiTrumpet } from "react-icons/gi";

const navigationListContent: ListItemLinkProps[] = [
  {
    icon: <HomeRoundedIcon/>,
    primary: 'Home',
    to: '/',
    hasDivider: true
  },
  {
    icon: <SvgIcon children={<GiMusicalScore/>} />,
    primary: 'Compositions',
    to: '/dashboard/compositions',
    hasDivider: false
  },
  {
    icon: <SvgIcon children={<GiTrumpet/>} />,
    primary: 'Instruments',
    to: '/dashboard/instruments',
    hasDivider: false
  }
];

interface DashboardOverlayProps {
  children: React.ReactNode
}

function DashboardOverlay({ children }: DashboardOverlayProps) {
  return (
    <Box sx={{ display: 'flex' }}>
      <CssBaseline />
      <Navbar />
      <DashboardSidebar drawerWidth={240} drawerListContent={navigationListContent} />
      <Box component="main" sx={{ flexGrow: 1, p: 3 }}>
        {children}
      </Box>
    </Box>
  )
}

export default DashboardOverlay
