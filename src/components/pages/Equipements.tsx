import React, { useState, useEffect } from 'react';
import { Table, Button, Space, Input, Modal, Form, message, QRCode } from 'antd';
import { EditOutlined, DeleteOutlined, ClockCircleOutlined, SearchOutlined, CheckCircleOutlined, CloseCircleOutlined } from '@ant-design/icons';
import Highlighter from 'react-highlight-words';
import { ColumnType } from 'antd/es/table';
import './Courses.css'; // Assuming you have CSS file
import moment from 'moment';
import LectureHallDropdown from '../buttons/LectureHallDropdown';
import StatusDropdown from '../buttons/StatusDropdown';
import AddCourseForm from '../buttons/AddCourseFormprops';
import EditCourseForm from '../buttons/EditCourse';
import axios from 'axios';
import AddEquipementForm from '../buttons/AddEquipement';

interface DataItem {
  _id: string;
  Equipementname: string;
  quantity: number;
  
}

const Equipements: React.FC = () => {
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
      const response = await fetch('http://localhost:3002/getequipement');
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
      await handleUpdateCourse({ _id: editRecord?._id, ...values }); // Ensure _id is included in the record
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
          const response = await axios.delete('http://localhost:3002/deleteEquipement', {
            data: { _id: record._id }, // Pass _id in the request body
          });
  
          if (response.status === 200) {
            const updatedData = data.filter((item) => item._id !== record._id);
            setData(updatedData);
            message.success('Equipement deleted successfully');
          } else {
            throw new Error('Failed to delete Equipement');
          }
        } catch (error) {
          console.error('Error deleting Equipement:', error);
          message.error('Failed to delete Equipement');
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
  // Function to handle adding a equipement

  const handleAddEquipement = async (values: any) => {
    try {
      const response = await axios.post('http://localhost:3002/addEquipement', values, {
        headers: {
          'Content-Type': 'application/json',
        },
      });
  
      if (response.status === 201) {
        const newEquipement = response.data;
        setData([...data, newEquipement]);
        setIsAddModalVisible(false);
        message.success('Equipement added successfully');
      } else {
        message.error('Failed to add Equipement');
      }
    } catch (error) {
      console.error('Error adding Equipement:', error);
      message.error('Failed to add Equipement');
    }
  };
  
  const handleUpdateCourse = async (record: DataItem) => {
    try {
      console.log('Updating course:', record._id);
      console.log('New values:', { Salle: record.Equipementname, status: record.quantity });
  
      const response = await axios.put('http://localhost:3002/updatequipement', {
        _id: record._id,
        Equipementname: record.Equipementname,
        quantity: record.quantity,
      });
      console.log(record._id);
      console.log(record.Equipementname);
      console.log(record.quantity);



      if (response.status === 200) {
        const updatedCourse = response.data;
        const updatedData = data.map((item) => {
          if (item._id === updatedCourse._id) {
            return updatedCourse;
          } else {
            return item;
          }
        });
        setData(updatedData);
        message.success('Course updated successfully');
      } else {
        console.error('Failed to update course. Unexpected response status:', response.status);
        message.error('Failed to update course. Unexpected response status. Please check console for details.');
      }
    } catch (error) {
      console.error('Error updating course:', error);
      message.error('Failed to update course. Please check console for details.');
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
      title: 'Equipement name',
      dataIndex: 'Equipementname',
      key: 'Equipementname',
      align: 'center',
      sorter: (a, b) => a.Equipementname.localeCompare(b.Equipementname),
      ...getColumnSearchProps('Equipementname'),
    },
    
      {
        title: 'Quantity',
        dataIndex: 'quantity',
        key: 'quantity',
        align: 'center',
        sorter: (a, b) => a.quantity - b.quantity,
        ...getColumnSearchProps('quantity'),
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
      <Button
        type="primary"
        style={{ marginBottom: 16, background: '#972929' }}
        onClick={showAddModal}
      >
        Add Equipement
      </Button>
      {/* AddCourseForm component */}
      <AddEquipementForm
        visible={isAddModalVisible}
        onCreate={handleAddEquipement}
        onCancel={handleAddCancel}
      />
      {/* EditCourseForm component */}
      {isEditModalVisible && editRecord && (
        <Modal
          title="Edit Record"
          visible={isEditModalVisible}
          onOk={handleEditOk}
          onCancel={handleEditCancel}
          okText="Save"
          cancelText="Cancel"
        >
          <Form
            form={form}
            name="edit-course-form"
            onFinish={handleUpdateCourse}
            initialValues={editRecord ? editRecord : {}}
          >
            <Form.Item
          name="Equipementname"
          label="Equipementname"
          rules={[{ required: true, message: 'Please enter the Equipement name' }]}
        >
          <Input />
        </Form.Item>

        <Form.Item
          label="quantity"
          name="quantity"
          rules={[{ required: true, message: 'Please enter the quantity!' }]}
        >
          <Input />
        </Form.Item>

            {/* Add more Form.Item components for other properties */}
          </Form>
        </Modal>
      )}
      {/* Table component */}
      <Table className="Courses-table" columns={columns} dataSource={data} scroll={{ x: true }} />
    </>
  );
};

export default Equipements;
