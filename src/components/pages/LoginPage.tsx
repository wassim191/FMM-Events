import React, { useEffect, useState } from 'react';
import { Card, Typography, Input, Button, Form } from 'antd';
import { useNavigate } from 'react-router-dom';
import axios from 'axios';
import Cookies from 'js-cookie'; // Import js-cookie library

import logo from '../../assets/logo/reddash.png';
import './LoginPage.css';

const { Title } = Typography;

const LoginPage: React.FC = () => {
  const [form] = Form.useForm();
  const navigate = useNavigate();
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const token = Cookies.get('user');
  
  useEffect(() => {
    if (token) {
      // Redirect to login if token is not present
      navigate('/layout');
    }
  }, [token, navigate]);

  const handleSubmit = async (values: any) => {
    const { username, password } = values;

    try {
      if (!username || !password) {
        setError('Please enter username and password.');
        return;
      }

      setLoading(true);

      const response = await axios.post('http://localhost:3002/signinAdmin4', { username, password });
      if (response.data.authenticated) {
        // Set cookie with JWT
        Cookies.set('user', response.data.token, { expires: 7 }); 
        navigate('/layout');
      } else {
        setError('Invalid username or password.');
      }
    } catch (error) {
      console.error(error);
      setError('An error occurred. Please try again.');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div style={{ display: 'flex', justifyContent: 'center', alignItems: 'center', height: '100vh' }}>
      <Card style={{ width: '600px', padding: '40px', borderRadius: '8px', boxShadow: '0 4px 8px rgba(0, 0, 0, 0.1)' }}>
        <div style={{ display: 'flex', justifyContent: 'center', marginBottom: '40px' }}>
          <img src={logo} alt="Red Dash Logo" style={{ width: '300px', height: '200px' }} />
        </div>
        <Title level={3} style={{ marginBottom: '20px', textAlign: 'center', fontSize: '30px' }}>Welcome!</Title>
        <Title style={{ marginBottom: '10px', textAlign: 'center', fontSize: '20px' }}>Log in to get access to FMM Events's Dashboard</Title>
        <Form form={form} onFinish={handleSubmit} layout="vertical">
          <Form.Item
            name="username"
            label="Username"
            rules={[{ required: true, message: 'Please input your username!' }]}
          >
            <Input placeholder="Username" />
          </Form.Item>
          <Form.Item
            name="password"
            label="Password"
            rules={[{ required: true, message: 'Please input your password!' }]}
          >
            <Input.Password placeholder="Password" />
          </Form.Item>
          <Form.Item>
            <Button type="primary" htmlType="submit" style={{ width: '100%', backgroundColor: '#972929' }} loading={loading}>
              Log In
            </Button>
          </Form.Item>
          {error && <div style={{ color: 'red', textAlign: 'center' }}>{error}</div>}
        </Form>
      </Card>
    </div>
  );
};

export default LoginPage;
