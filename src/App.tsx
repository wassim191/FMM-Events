// App.tsx
import React from 'react';
import { BrowserRouter as Router, Route, Routes } from 'react-router-dom';
import MyLayout from './components/layout/layout';
import HomePage from './components/pages/Homepage';
import CoursePage from './components/pages/Coursepage';
import Learners from './components/pages/users/Learners';
import Instructors from './components/pages/users/Instructors';
import CalendarPage from './components/pages/CalanderPage';
import Admins from './components/pages/users/Admins';
import LoginPage from './components/pages/LoginPage'; // Import the LoginPage component
import Scanqrcode from './components/pages/Scanqrcode';
import Registred from './components/pages/RegisterPage';
import Equipements from './components/pages/Equipements';

const App: React.FC = () => {
  const handleLogin = (username: string, password: string) => {
    console.log('Logging in with username:', username, 'and password:', password);
    // Implement your login logic here
  };

  return (
    <Router>
      <Routes>
        <Route path="/" element={<LoginPage  />} />
        <Route path="/layout" element={<MyLayout />}>
          <Route path="" element={<HomePage />} />
          <Route path="courses" element={<CoursePage />} />
          <Route path="learners" element={<Learners />} />
          <Route path="instructors" element={<Instructors />} />
          <Route path="admins" element={<Admins />} />
          <Route path="calendar" element={<CalendarPage />} />
          <Route path="scanqrcode" element={<Scanqrcode />} />
          <Route path="registered" element={<Registred />} />
          <Route path="Equipements" element={<Equipements />} />
        </Route>
      </Routes>
    </Router>
  );
};

export default App;
