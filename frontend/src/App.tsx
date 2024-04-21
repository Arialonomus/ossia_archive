import './App.css'
import { Routes, Route } from 'react-router-dom';
import DashboardOverlay from './components/dashboard/toolbars/DashboardOverlay.tsx';

// Import Pages *************************************************
// Dashboard
import DashboardHomePage from './pages/dashboard/DashboardHomePage.tsx';
import CompositionsPage from './pages/dashboard/CompositionsPage.tsx';
import InstrumentsPage from './pages/dashboard/InstrumentsPage.tsx';

function App() {

  return (
    <>
      {/* Dashboard Routes */}
      <DashboardOverlay>
        <Routes>
          <Route path='/' element={<DashboardHomePage />} />
          <Route path='/dashboard/compositions' element={<CompositionsPage/>} />
          <Route path='/dashboard/instruments' element={<InstrumentsPage/>} />
        </Routes>
      </DashboardOverlay>
    </>
  )
}

export default App
