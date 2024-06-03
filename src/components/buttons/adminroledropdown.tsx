import React from 'react';
import { Menu, Dropdown, Button, message } from 'antd';
import { CheckCircleOutlined, CloseCircleOutlined, ClockCircleOutlined } from '@ant-design/icons';

interface AdminddropdownProps {
  onChange: (Role: string) => void;
  value?: string;
}

const Adminddropdown: React.FC<AdminddropdownProps> = ({ onChange, value }) => {
  const handleMenuClick = (e: any) => {
    onChange(e.key);
    message.info(`Selected Role: ${e.key}`);
  };

  const menu = (
    <Menu onClick={handleMenuClick}>
  
      <Menu.Item key="SuperAdmin"  >
        SuperAdmin
      </Menu.Item>
      <Menu.Item key="Admin" >
      Admin
      </Menu.Item>
    </Menu>
  );

  return (
    <Dropdown overlay={menu}>
      <Button>
        Select Role
      </Button>
    </Dropdown>
  );
};

export default Adminddropdown;
