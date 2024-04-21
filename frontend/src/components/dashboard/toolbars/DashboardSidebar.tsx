import { Box, Drawer, Toolbar } from '@mui/material';
import { List } from '@mui/material';
import { ListItemLink, ListItemLinkProps } from '../../common/list/ListItemLink.tsx';

interface DashboardSidebarProps {
  drawerWidth: number
  drawerListContent: ListItemLinkProps[]
}

function DashboardSidebar({ drawerWidth, drawerListContent }: DashboardSidebarProps) {
  return (
    <Drawer
      variant="permanent"
      sx={{
        width: drawerWidth,
        flexShrink: 0,
        [`& .MuiDrawer-paper`]: { width: drawerWidth, boxSizing: 'border-box' },
      }}
    >
      <Toolbar />
      <Box sx={{ overflow: 'auto' }}>
        <List>
          {drawerListContent.map((item) => (
            <ListItemLink
              key={item.primary}
              icon={item.icon}
              primary={item.primary}
              to={item.to}
              hasDivider={item.hasDivider}
            />
          ))}
        </List>
      </Box>
    </Drawer>
  )
}

export default DashboardSidebar
