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

interface DataItem {
  _id: string;
  qrCode: string;
  images: string;
  Prof: string;
  category: string;
  description: string;
  quantity: number;
  price: number;
  timeofstart: Date;
  timeofend: Date;
  Date: Date;
  Salle: string;
  Tel: string;
  status: string;
  email:string;
}

const CoursePage: React.FC = () => {
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
      const response = await fetch('http://localhost:3002/getcourse');
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
          const response = await fetch(`http://localhost:3002/deletecourse`, {
            method: 'DELETE',
            headers: {
              'Content-Type': 'application/json'
            },
            body: JSON.stringify({ _id: record._id })
          });

          if (response.ok) {
            const updatedData = data.filter((item) => item._id !== record._id);
            setData(updatedData);
            message.success('Course deleted successfully');
          } else {
            throw new Error('Failed to delete course');
          }
        } catch (error) {
          console.error('Error deleting course:', error);
          message.error('Failed to delete course');
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
  const handleAddCourse = async (values: any) => {
    try {
      const response = await fetch('http://localhost:3002/addthecourse', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(values),
      });
      if (response.ok) {
        const newCourse = await response.json();
        setData([...data, newCourse]);
        setIsAddModalVisible(false);
        message.success('Course added successfully');
      } else {
        message.error('Failed to add course');
      }
    } catch (error) {
      console.error('Error adding course:', error);
      message.error('Failed to add course');
    }
  };

  const handleUpdateCourse = async (record: DataItem) => {
    try {
      console.log('Updating course:', record._id);
      console.log('New values:', { Salle: record.Salle, status: record.status });
  
      const response = await axios.put('http://localhost:3002/updatecourse', {
        _id: record._id,
        Salle: record.Salle,
        status: record.status,
      });
      console.log(record._id);
      console.log(record.Salle);
      console.log(record.status);



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
      title: 'QR-Code',
      dataIndex: 'qrCode',
      key: 'qrCode',
      align: 'center',
      render: (text, record) => {
        if (record.status === 'pending') {
          return <QRCode value={`Course ID: ${record._id}`} status='loading' size={70} className="qr-code" dot-color="#a24141" />;
        } else if (record.status === 'active') {
          return <QRCode value={`Course ID: ${record._id}`} color="green" size={70} />;
        } else if (record.status === 'notactive') {
          return <QRCode value={`Course ID: ${record._id}`} color="red" size={70}/>;
        }
        return null;
      },
    },
    {
      title: 'Instructor Name',
      dataIndex: 'Prof',
      key: 'Prof',
      align: 'center',
      sorter: (a, b) => a.Prof.localeCompare(b.Prof),
      ...getColumnSearchProps('Prof'),
    },
    {
      title: 'Email',
      dataIndex: 'email',
      key: 'email',
      align: 'center',
      sorter: (a, b) => a.email.localeCompare(b.email),
      ...getColumnSearchProps('email'),
    },
    {
      title: 'Category',
      dataIndex: 'category',
      key: 'category',
      align: 'center',
      sorter: (a, b) => a.category.localeCompare(b.category),
      ...getColumnSearchProps('category'),
    },
    {
        title: 'Description',
        dataIndex: 'description',
        key: 'description',
        align: 'center',
        sorter: (a, b) => a.description.localeCompare(b.description),
        ...getColumnSearchProps('description'),
      },
    
    {
      title: 'Time of Start',
      dataIndex: 'Timeofstart',
      key: 'Timeofstart',
      align: 'center',
      sorter: (a: DataItem, b: DataItem) => a.timeofstart.valueOf() - b.timeofstart.valueOf(),
      ...getColumnSearchProps('timeofstart'),
      render: (timeofstart) => {
        return moment(timeofstart).format('HH:mm');
      }
    },
    {
      title: 'Time of End',
      dataIndex: 'Timeofend',
      key: 'Timeofend',
      align: 'center',
      sorter: (a: DataItem, b: DataItem) => a.timeofstart.valueOf() - b.timeofstart.valueOf(),
      ...getColumnSearchProps('timeofend'),
      render: (timeofend) => {
        return moment(timeofend).format('HH:mm');
      }
    },
    {
      title: 'Date',
      dataIndex: 'Date',
      key: 'Date',
      align: 'center',
      sorter: (a, b) => a.Date.valueOf() - b.Date.valueOf(),
      ...getColumnSearchProps('Date'),
      render: (date) => {
        return moment(date).format('DD/MM/YYYY');
      }
    },
    {
      title: 'Lecture Hall',
      dataIndex: 'Salle',
      key: 'Salle',
      align: 'center',
      sorter: (a, b) => a.Salle.localeCompare(b.Salle),
      ...getColumnSearchProps('Salle'),
    },
    {
        title: 'Price',
        dataIndex: 'price',
        key: 'price',
        align: 'center',
        sorter: (a, b) => a.price - b.price,
        render: (text, record) => {
          if (record.price === 0) {
            return "Free";
          }else{
            return record.price+' DT';
          }
        }
      },
      {
        title: 'Tel Number',
        dataIndex: 'Tel',
        key: 'Tel',
        align: 'center',
        sorter: (a, b) => a.Tel.localeCompare(b.Tel),
        ...getColumnSearchProps('Tel'),
      },
      {
        title: 'Registred',
        dataIndex: 'quantity',
        key: 'quantity',
        align: 'center',
        sorter: (a, b) => a.quantity - b.quantity,
        ...getColumnSearchProps('quantity'),
      },
      {
        title: 'Status',
        dataIndex: 'status',
        key: 'status',
        align: 'center',
        render: (status: string) => {
          let color = '';
          let icon = null;
      
          switch (status) {
            case 'pending':
              color = '#a24141';
              icon = <ClockCircleOutlined />;
              break;
            case 'active':
              color = 'green';
              icon = <CheckCircleOutlined />;
              break;
            case 'notactive':
              color = 'red';
              icon = <CloseCircleOutlined />;
              break;
            default:
              break;
          }
      
          return (
            <span style={{ color }}>
              {icon} {status}
            </span>
          );
        },
        sorter: (a, b) => a.status.localeCompare(b.status),
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
        Add Courses
      </Button>
      {/* AddCourseForm component */}
      <AddCourseForm
        visible={isAddModalVisible}
        onCreate={handleAddCourse}
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
              label="Lecture Hall"
              name="Salle"
              rules={[{ required: true, message: 'Please select a lecture hall!' }]}
            >
              <LectureHallDropdown onChange={(value) => form.setFieldsValue({ Salle: value })} />
            </Form.Item>

            <Form.Item
              label="Status"
              name="status"
              rules={[{ required: true, message: 'Please select a status!' }]}
            >
              <StatusDropdown onChange={(value) => form.setFieldsValue({ status: value })} />
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

export default CoursePage;
