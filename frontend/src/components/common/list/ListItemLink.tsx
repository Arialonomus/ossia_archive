import React from 'react';
import ListItem from '@mui/material/ListItem';
import ListItemButton from '@mui/material/ListItemButton';
import ListItemIcon from '@mui/material/ListItemIcon';
import ListItemText from '@mui/material/ListItemText';
import Divider from '@mui/material/Divider'
import { Link as RouterLink, LinkProps as RouterLinkProps } from 'react-router-dom';

export interface ListItemLinkProps {
  icon?: React.ReactElement;
  primary: string;
  to: string;
  hasDivider: boolean
}

const Link = React.forwardRef<HTMLAnchorElement, RouterLinkProps>(
  function Link(itemProps, ref) {
    return <RouterLink ref={ref} {...itemProps} role={undefined} />;
  },
);

export function ListItemLink({ icon, primary, to, hasDivider }: ListItemLinkProps) {
  return (
    <>
      <ListItem disablePadding>
        <ListItemButton component={Link} to={to}>
          {icon ? <ListItemIcon>{icon}</ListItemIcon> : null}
          <ListItemText primary={primary} />
        </ListItemButton>
      </ListItem>
      {hasDivider && <Divider/>}
    </>
  );
}