import React, { useEffect, useState } from 'react';
import { Link, Outlet, useNavigate } from 'react-router-dom';
import './layout.css'
import { Layout, Menu, Button, Modal } from 'antd';
import {
  PieChartOutlined,
  DesktopOutlined,
  UserOutlined,
  TeamOutlined,
  FileOutlined,
  ScheduleOutlined,
  LineChartOutlined,
  QrcodeOutlined,
} from '@ant-design/icons';
import logo from '../../assets/logo/reddash.png';
import Cookies from 'js-cookie';
import axios from 'axios';

const { Header, Content, Footer, Sider } = Layout;
const { SubMenu } = Menu;

const MyLayout = () => {
  const [collapsed, setCollapsed] = useState<boolean>(false);
  const [selectedKeys, setSelectedKeys] = useState<string[]>(['1']);
  const token = Cookies.get('user');
  const navigate = useNavigate();

  useEffect(() => {
    if (!token) {
      // Redirect to login if token is not present
      navigate('/');
    }
  }, [token, navigate]);

  const onCollapse = (collapsed: boolean) => {
    setCollapsed(collapsed);
  };

  const handleClick = (e: { key: React.Key }) => {
    const key = e.key.toString();
    setSelectedKeys([key]);
  };

  const handleLogoClick = () => {
    setSelectedKeys([]);
  };

  const SignOutButton = () => {
    const [visible, setVisible] = useState(false);
    const navigate = useNavigate();
  
    const handleSignOut = async () => {
      try {
        await axios.post('http://localhost:3002/signoutAdmin');
        // Clear the token cookie
        Cookies.remove('user');
        navigate('/');
      } catch (err) {
        console.error(err);
        // Handle error
      }
    };

    return (
      <>
        <Button
          icon={<UserOutlined />}
          style={{ background: '#FFBE98', border: 'none', transition: 'background 0.3s' }}
          className="hover-red"
          onClick={() => setVisible(true)}
        />
        <Modal
          title="Sign Out"
          visible={visible}
          onOk={handleSignOut}
          onCancel={() => setVisible(false)}
          okText="Sign Out"
          cancelText="Cancel"
        >
          <p>Are you sure you want to sign out?</p>
        </Modal>
      </>
    );
  };

  return (
    <Layout style={{ minHeight: '100vh' }}>
      <Header className="header" style={{ padding: '0 16px', background: '#FFBE98', display: 'flex', justifyContent: 'space-between', alignItems: 'center'}}>
      <div className="logo" style={{ display: 'flex', justifyContent: 'center' , marginTop:'20px' }}>
      <Link to="" onClick={handleLogoClick}>
        <img src={logo} alt="Dashboard Logo" className="logo" style={{ width: '250px', height: '130px', alignSelf: 'center' }} />
        </Link>
      </div>
        <div className="header-icons">
        <SignOutButton />
        </div>
      </Header>
      <Layout>
        <Sider collapsible collapsed={collapsed} onCollapse={onCollapse} style={{ background: '#a24141' }} >
          <div className="logo" />
          <Menu theme="light" selectedKeys={selectedKeys} onClick={handleClick} mode="inline"style={{ background: '#a24141' }}>
            <Menu.Item key="1" icon={<PieChartOutlined />}>
            <Link to="/layout" style={{ color: 'white' }}>Main Dashboard</Link>
            </Menu.Item>
            <Menu.Item key="2" icon={<DesktopOutlined />}>
            <Link to="courses" style={{ color: 'white' }}>Courses</Link>
            </Menu.Item>
            <SubMenu key="sub1" icon={<UserOutlined />} title="Users"style={{ background: '#a24141' }}>
            <Menu.Item key="3" style={{ background: '#a24141' }}>
                <Link to="learners" style={{ color: 'white' }}>Learners</Link></Menu.Item>
              <Menu.Item key="4" style={{ background: '#a24141' }}>
                <Link to="instructors" style={{ color: 'white' }}>Instructors</Link></Menu.Item>
              <Menu.Item key="5" style={{ background: '#a24141' }}>
              <Link to="admins" style={{ color: 'white' }}>Admins</Link>
              </Menu.Item>
              <Menu.Item key="10" style={{ background: '#a24141' }}>
              <Link to="registered " style={{ color: 'white' }}>Registred</Link>
              </Menu.Item>
            </SubMenu>
            <SubMenu key="sub2" icon={<ScheduleOutlined />} title="Scheduale"style={{ background: '#a24141' }}>
              <Menu.Item key="6" style={{ background: '#a24141' }}>
              <Link to="calendar" style={{ color: 'white' }}>Calendar</Link>
                </Menu.Item>
            </SubMenu>
            {/* <SubMenu key="sub3" icon={<LineChartOutlined />} title="Charts"style={{ background: '#a24141' }}>
              <Menu.Item key="11" style={{ background: '#a24141' }}>
              <Link to="userdistribution" style={{ color: 'white' }}>User Distribution</Link>
                </Menu.Item>
              <Menu.Item key="12" style={{ background: '#a24141' }}>
              <Link to="useractivity" style={{ color: 'white' }}>User Activity</Link>
              </Menu.Item>

             
              <Menu.Item key="13" style={{ background: '#a24141' }}>Course Status Overview</Menu.Item>
              <Menu.Item key="14" style={{ background: '#a24141' }}>Course Category Distribution</Menu.Item>
            </SubMenu> */}
            <Menu.Item key="16" icon={<DesktopOutlined />}>
            <Link to="Equipements" style={{ color: 'white' }}>Equipements</Link>
            </Menu.Item>
            <Menu.Item key="9" icon={<FileOutlined />} >
              Diplome
            </Menu.Item>
            <Menu.Item key="15" icon={<QrcodeOutlined />} style={{ background: '#a24141' }}>
  <Link to="scanqrcode" style={{ color: 'white' }}>Scan QR Code</Link>
</Menu.Item>


          </Menu>
        </Sider>
        <Layout className="site-layout">
          <Content style={{ background:'#FEECE2' }}>
            <div className="site-layout-background" style={{ padding: 24, minHeight: 360 }}>
              <Outlet /> {/* Render nested routes */}
            </div>
          </Content>
          <Footer style={{ textAlign: 'center',background:'#FEECE2' }}>FMM ©2024 Created by SmartLab</Footer>
        </Layout>
      </Layout>
    </Layout>
  );
};

export default MyLayout;