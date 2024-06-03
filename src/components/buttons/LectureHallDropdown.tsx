import React, { useState } from 'react';
import { Menu, Dropdown, Button, message, Modal, Form, Input } from 'antd';
import { BankOutlined, DownOutlined, PlusOutlined } from '@ant-design/icons';

interface LectureHallDropdownProps {
  onChange: (hall: string) => void;
  value?: string;
}

const LectureHallDropdown: React.FC<LectureHallDropdownProps> = ({ onChange, value }) => {
  const [isModalVisible, setIsModalVisible] = useState<boolean>(false);
  const [newHallName, setNewHallName] = useState<string>('');

  const handleMenuClick = (e: any) => {
    if (e.key === 'Add Hall') {
      showModal();
    } else {
      onChange(e.key);
      message.info(`Selected hall: ${e.key}`);
    }
  };

  const showModal = () => {
    setIsModalVisible(true);
  };

  const handleOk = () => {
    // Add logic to handle adding the new hall
    onChange(newHallName);
    message.success(`Added new hall: ${newHallName}`);
    setIsModalVisible(false);
  };

  const handleCancel = () => {
    setIsModalVisible(false);
  };

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setNewHallName(e.target.value);
  };

  const menu = (
    <Menu onClick={handleMenuClick}>
      <Menu.Item key="Amphie A" icon={<BankOutlined />}>
        Amphie A
      </Menu.Item>
      <Menu.Item key="Amphie B" icon={<BankOutlined />}>
        Amphie B
      </Menu.Item>
      <Menu.Item key="Amphie C" icon={<BankOutlined />}>
        Amphie C
      </Menu.Item>
      <Menu.Item key="Amphie D" icon={<BankOutlined />}>
        Amphie D
      </Menu.Item>
      <Menu.Item key="Add Hall" icon={<PlusOutlined />}>
        Add Hall
      </Menu.Item>
    </Menu>
  );

  return (
    <>
      <Dropdown overlay={menu}>
        <Button>
          Select Lecture Hall <DownOutlined />
        </Button>
      </Dropdown>
      <Modal title="Add New Lecture Hall" visible={isModalVisible} onOk={handleOk} onCancel={handleCancel}>
        <Form>
          <Form.Item label="New Hall Name">
            <Input value={newHallName} onChange={handleChange} />
          </Form.Item>
        </Form>
      </Modal>
    </>
  );
};

export default LectureHallDropdown;
