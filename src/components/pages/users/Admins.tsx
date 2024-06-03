import React, { useState, useEffect } from 'react';
import { Table, Button, Space, Input, Modal, Form, message, QRCode } from 'antd';
import { EditOutlined, DeleteOutlined, ClockCircleOutlined, SearchOutlined, CheckCircleOutlined, CloseCircleOutlined } from '@ant-design/icons';
import Highlighter from 'react-highlight-words';
import { ColumnType } from 'antd/es/table';
import moment from 'moment';
import axios from 'axios';
import './Admins.css'
import AddAdminsForm from '../../buttons/AddAdmin';
import EditAdminsForm from '../../buttons/EditAdmins';
import Password from 'antd/es/input/Password';
interface DataItem {
  _id: string;
  username: string;
  password: string;
  role: string;
}

const Adminspage: React.FC = () => {
  // State variables
  const [data, setData] = useState<DataItem[]>([]);
  const [searchText, setSearchText] = useState<string>('');
  const [searchedColumn, setSearchedColumn] = useState<string>('');
  const [form] = Form.useForm();
  const [isEditModalVisible, setIsEditModalVisible] = useState<boolean>(false);
  const [editRecord, setEditRecord] = useState<DataItem | null>(null);
  const [isAddModalVisible, setIsAddModalVisible] = useState<boolean>(false);

  // Fetch courses on component mount
  useEffect(() => {
    fetchCourses();
  }, []);

  // Fetch courses function
  const fetchCourses = async () => {
    try {
      const response = await fetch('http://localhost:3002/getAdmins');
      const courses = await response.json();
      setData(courses);
    } catch (error) {
      console.error('Error fetching courses:', error);
    }
  };

  // Function to create column search props
  const getColumnSearchProps = (dataIndex: keyof DataItem) => ({
    filterDropdown: ({ setSelectedKeys, selectedKeys, confirm, clearFilters }: any) => (
      <div style={{ padding: 8 }}>
        <Input
          id="searchInput"
          ref={(node) => {
            if (node) {
              node.focus();
            }
          }}
          placeholder={`Search ${dataIndex}`}
          value={selectedKeys[0] as string}
          onChange={(e) => setSelectedKeys(e.target.value ? [e.target.value] : [])}
          onPressEnter={() => handleSearch(selectedKeys, confirm, dataIndex)}
          style={{ width: 188, marginBottom: 8, display: 'block' }}
        />
        <Space>
          <Button
            type="primary"
            onClick={() => handleSearch(selectedKeys, confirm, dataIndex)}
            icon={<SearchOutlined />}
            size="small"
            style={{ width: 90 }}
          >
            Search
          </Button>
          <Button onClick={() => handleReset(clearFilters)} size="small" style={{ width: 90 }}>
            Reset
          </Button>
        </Space>
      </div>
    ),
    filterIcon: (filtered: boolean) => <SearchOutlined style={{ color: filtered ? '#1890ff' : undefined }} />,
    onFilter: (value: any, record: DataItem) =>
      record[dataIndex].toString().toLowerCase().includes(value.toLowerCase()),
    onFilterDropdownVisibleChange: (visible: boolean) => {
      if (visible) {
        setTimeout(() => {
          const element = document.getElementById('searchInput');
          if (element) {
            element.focus();
          }
        });
      }
    },
    render: (text: string) =>
      searchedColumn === dataIndex ? (
        <Highlighter
          highlightStyle={{ backgroundColor: '#ffc069', padding: 0 }}
          searchWords={[searchText]}
          autoEscape
          textToHighlight={text.toString()}
        />
      ) : (
        text
      ),
  });

  // Function to handle search
  const handleSearch = (selectedKeys: React.Key[], confirm: () => void, dataIndex: string) => {
    confirm();
    setSearchText(selectedKeys[0] as string);
    setSearchedColumn(dataIndex);
  };

  // Function to handle reset
  const handleReset = (clearFilters: (() => void) | undefined) => {
    if (clearFilters) {
      clearFilters();
    }
    setSearchText('');
  };

  // Function to show edit modal
  const showEditModal = (record: DataItem) => {
    setEditRecord(record);
    setIsEditModalVisible(true);
  };
  
  // Function to handle edit modal cancel
  const handleEditCancel = () => {
    setIsEditModalVisible(false);
  };
  
  // Function to handle edit modal ok
  const handleEditOk = async (): Promise<void> => {
    try {
      const values = await form.validateFields(); // Validate fields first
      await handleUpdateAdmin({ _id: editRecord?._id, ...values }); // Ensure _id is included in the record
      setIsEditModalVisible(false);
    } catch (error) {
      console.error('Error editing course:', error);
      message.error('Failed to edit course');
    }
  };
  

  // Function to handle delete
  const handleDelete = (record: DataItem) => {
    Modal.confirm({
      title: 'Confirm Delete',
      content: 'Are you sure you want to delete this record?',
      onOk: async () => {
        try {
          const response = await fetch(`http://localhost:3002/deleteAdmin`, {
            method: 'DELETE',
            headers: {
              'Content-Type': 'application/json'
            },
            body: JSON.stringify({ _id: record._id })
          });

          if (response.ok) {
            const updatedData = data.filter((item) => item._id !== record._id);
            setData(updatedData);
            message.success('Admin deleted successfully');
          } else {
            throw new Error('Failed to delete Admin');
          }
        } catch (error) {
          console.error('Error deleting Admin:', error);
          message.error('Failed to delete Admin');
        }
      },
      onCancel: () => {
        console.log('Delete canceled');
      },
    });
  };

  // Function to show add modal
  const showAddModal = () => {
    setIsAddModalVisible(true);
  };

  // Function to handle add modal cancel
  const handleAddCancel = () => {
    setIsAddModalVisible(false);
  };


  // Function to handle adding a course
  const handleAddAdmin = async (values: any) => {
    try {
      const response = await fetch('http://localhost:3002/signupadmin', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(values),
      });
      if (response.ok) {
        const newAdmin = await response.json();
        setData([...data, newAdmin]);
        setIsAddModalVisible(false);
        message.success('Admin added successfully');
      } else {
        message.error('Failed to add Admin');
      }
    } catch (error) {
      console.error('Error adding Admin:', error);
      message.error('Failed to add Admin');
    }
   
  };

  const handleUpdateAdmin= async (record: DataItem) => {
    try {
      console.log('Updating course:', record._id);
      console.log('New values:', { username: record.username, Password: record.password,role: record.role });
  
      const response = await axios.put('http://localhost:3002/updateAdmin', {
        _id: record._id,
        username: record.username, Password: record.password,role: record.role
      });
      console.log(record._id);
      console.log(record.username);
      console.log(record.password);



      if (response.status === 200) {
        const updatedAdmin = response.data;
        const updatedData = data.map((item) => {
          if (item._id === updatedAdmin._id) {
            return updatedAdmin;
          } else {
            return item;
          }
        });
        setData(updatedData);
        message.success('Admin updated successfully');
      } else {
        console.error('Failed to update Admin. Unexpected response status:', response.status);
        message.error('Failed to update Admin. Unexpected response status. Please check console for details.');
      }
    } catch (error) {
      console.error('Error updating Admin:', error);
      message.error('Failed to update Admin. Please check console for details.');
    }
  };
  
  
  
  const columns: ColumnType<DataItem>[] = [
    {
      title: 'ID',
      dataIndex: '_id',
      key: '_id',
      align: 'center',
      ...getColumnSearchProps('_id'),
    },
  
    {
      title: 'username',
      dataIndex: 'username',
      key: 'username',
      align: 'center',
      sorter: (a, b) => a.username.localeCompare(b.username),
      ...getColumnSearchProps('username'),
    },
    {
      title: 'password',
      dataIndex: 'password',
      key: 'password',
      align: 'center',
      sorter: (a, b) => a.password.localeCompare(b.password),
      ...getColumnSearchProps('password'),
    },
    {
      title: 'role',
      dataIndex: 'role',
      key: 'role',
      align: 'center',
      sorter: (a, b) => a.role.localeCompare(b.role),
      ...getColumnSearchProps('role'),
    },
  
      {
        title: 'Action',
        key: 'action',
        align: 'center',
        render: (text: string, record: DataItem) => (
          <Space size="middle">
            <Button
              type="link"
              onClick={() => showEditModal(record)}
              icon={<EditOutlined style={{ color: 'green' }} />}
            >
              
            </Button>
            <Button
              type="link"
              onClick={() => handleDelete(record)}
              icon={<DeleteOutlined style={{ color: 'red' }} />}
            >
              
            </Button>
          </Space>
        ),
      },
    // Column definitions
  ];

  return (
    <>
      {/* Button to add courses */}
      <Button type="primary" style={{ marginBottom: 16 ,background: '#972929' }}onClick={showAddModal}>
        Add Admin
      </Button>
      <AddAdminsForm
  visible={isAddModalVisible}
  // Pass the roles array here
  onCreate={(values) => {
    // Handle form submission
    console.log('Add form submitted with values:', values);
    handleAddAdmin(values);
  }}
  onCancel={handleAddCancel}
/>
      {/* EditCourseForm component */}
      {isEditModalVisible && editRecord && (
        <EditAdminsForm
          visible={isEditModalVisible}
          initialValues={editRecord}
          onUpdate={handleUpdateAdmin}
          onCancel={handleEditCancel}
        />
      )}
      {/* Table component */}
      <Table className="Admins-table" columns={columns} dataSource={data} scroll={{ x: true }} />
    </>
  );
};

export default Adminspage;
