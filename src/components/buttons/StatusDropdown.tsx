import React from 'react';
import { Menu, Dropdown, Button, message } from 'antd';
import { CheckCircleOutlined, CloseCircleOutlined, ClockCircleOutlined } from '@ant-design/icons';

interface StatusDropdownProps {
  onChange: (status: string) => void;
  value?: string;
}

const StatusDropdown: React.FC<StatusDropdownProps> = ({ onChange, value }) => {
  const handleMenuClick = (e: any) => {
    onChange(e.key);
    message.info(`Selected status: ${e.key}`);
  };

  const menu = (
    <Menu onClick={handleMenuClick}>
      <Menu.Item key="pending" icon={<ClockCircleOutlined style={{ color: '#faad14' }}  />}>
        Pending
      </Menu.Item>
      <Menu.Item key="active" icon={<CheckCircleOutlined style={{ color: '#52c41a' }} />}>
        Accepted
      </Menu.Item>
      <Menu.Item key="notactive" icon={<CloseCircleOutlined style={{ color: '#f5222d' }} />}>
        Refused
      </Menu.Item>
    </Menu>
  );

  return (
    <Dropdown overlay={menu}>
      <Button>
        Select Status
      </Button>
    </Dropdown>
  );
};

export default StatusDropdown;
