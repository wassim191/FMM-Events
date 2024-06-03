import React, { useState, useEffect } from 'react';
import { Table, Input, Button, Space, Modal, message } from 'antd';
import { SearchOutlined, CheckCircleOutlined, CloseCircleOutlined, DeleteOutlined, EditOutlined } from '@ant-design/icons';
import Highlighter from 'react-highlight-words';
import QRCode from 'qrcode.react';
import EditRegisteredForm from '../../components/buttons/EditRegistered';
import './Registerpage.css'; // Assuming you have CSS file
import { ColumnType } from 'antd/es/table';
import axios from 'axios';

interface DataItem {
  _id: number;
  name: string;
  Profname: string;
  email: string;
  status: string;
  category: string;
  idcourse: string;
  qrCode: string;
  Attendance: boolean;
}

const Registered: React.FC = () => {
  const [searchText, setSearchText] = useState<string>('');
  const [searchedColumn, setSearchedColumn] = useState<string>('');
  const [isEditFormVisible, setEditFormVisible] = useState(false);
  const [editRecord, setEditRecord] = useState<DataItem | null>(null);
  const [data, setData] = useState<DataItem[]>([]);

  useEffect(() => {
    fetchCourse();
  }, []);

  const fetchCourse = async () => {
    try {
      const response = await fetch('http://localhost:3002/getregister');
      const courses = await response.json();
      setData(courses);
    } catch (error) {
      console.error('Error fetching courses:', error);
    }
  };

  const showEditForm = (record: DataItem) => {
    setEditRecord(record);
    setEditFormVisible(true);
  };

  const hideEditForm = () => {
    setEditFormVisible(false);
    setEditRecord(null);
  };

  const handleDelete = (record: DataItem) => {
    Modal.confirm({
      title: 'Confirm Delete',
      content: 'Are you sure you want to delete this record?',
      onOk: () => {
        axios.delete('http://localhost:3002/deleteregister', {
          data: { _id: record._id }
        })
        .then(response => {
          const newData = data.filter(item => item._id !== record._id);
          setData(newData);
          message.success(response.data.message);
        })
        .catch(error => {
          console.error(error);
          message.error('Failed to delete record');
        });
      },
      onCancel: () => {
        console.log('Delete canceled');
      },
    });
  };
  

  const getColumnSearchProps = (dataIndex: keyof DataItem) => ({
    filterDropdown: ({ setSelectedKeys, selectedKeys, confirm, clearFilters }: any) => (
      <div style={{ padding: 8 }}>
        <Input
          placeholder={`Search ${dataIndex}`}
          value={selectedKeys[0]}
          onChange={e => setSelectedKeys(e.target.value ? [e.target.value] : [])}
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

  const handleSearch = (selectedKeys: any, confirm: any, dataIndex: any) => {
    confirm();
    setSearchText(selectedKeys[0]);
    setSearchedColumn(dataIndex);
  };

  const handleReset = (clearFilters: any) => {
    clearFilters();
    setSearchText('');
  };

  const onUpdate = async (updatedValues: DataItem) => {
      axios.put(`http://localhost:3002/updatregister`, updatedValues)
      .then(response => {
        const newData = data.map(item => {
          if (item._id === updatedValues._id) {
            return { ...item, ...updatedValues };
          }
          return item;
        });
        setData(newData);
        message.success(response.data.message);
        hideEditForm();
    }) .catch(error => {
      console.error(error);
      message.error('Failed to update Register');
    });
  };
  

  const columns : ColumnType<DataItem>[] = [
    {
      title: 'ID',
      dataIndex: '_id',
      key: '_id',
      sorter: (a: DataItem, b: DataItem) => a._id - b._id,
      ...getColumnSearchProps('_id'),
    },
    {
      title: 'Name',
      dataIndex: 'name',
      key: 'name',
      ...getColumnSearchProps('name'),
    },
    {
      title: 'Email',
      dataIndex: 'email',
      key: 'email',
      ...getColumnSearchProps('email'),
    },
    {
      title: 'Prof Name',
      dataIndex: 'Profname',
      key: 'Profname',
      ...getColumnSearchProps('Profname'),
    },
    {
      title: 'Status',
      dataIndex: 'status',
      key: 'status',
      align: 'center',
      render: (status: string) => (
        <span style={{ color: status === 'Paid' ? 'green' : 'red' }}>
          {status === 'Paid' ? <CheckCircleOutlined /> : <CloseCircleOutlined />}
        </span>
      ),
      sorter: (a: DataItem, b: DataItem) => (a.status === 'Paid' ? 1 : -1) - (b.status === 'Paid' ? 1 : -1),
    },
    {
      title: 'Category',
      dataIndex: 'category',
      key: 'category',
      ...getColumnSearchProps('category'),
    },
    {
      title: 'Course ID',
      dataIndex: 'idcourse',
      key: 'idcourse',
      ...getColumnSearchProps('idcourse'),
    },
    {
      title: 'QR-Code',
      dataIndex: 'qrCode',
      key: 'qrCode',
      render: (text: string, record: DataItem) => (
        <QRCode value={`Course ID: ${record._id}`} color="green" size={70} />
      ),
    },
    {
      title: 'Attendance',
      dataIndex: 'Attendance',
      key: 'Attendance',
      align: 'center',
      render: (Attendance: boolean) => (
        <span style={{ color: Attendance ? 'green' : 'red' }}>
          {Attendance ? <CheckCircleOutlined /> : <CloseCircleOutlined />}
        </span>
      ),
      sorter: (a: DataItem, b: DataItem) => (a.Attendance ? 1 : -1) - (b.Attendance ? 1 : -1),
    },
    {
      title: 'Action',
      key: 'action',
      align: 'center',
      render: (text: string, record: DataItem) => (
        <Space size="middle">
          <EditOutlined style={{ color: 'green' }} onClick={() => showEditForm(record)} />
          <DeleteOutlined style={{ color: 'red' }} onClick={() => handleDelete(record)} />
        </Space>
      ),
    },
  ];

  return (
    <>
      {isEditFormVisible && editRecord && (
        <EditRegisteredForm
          visible={isEditFormVisible}
          initialValues={editRecord}
          onUpdate={onUpdate}
          onCancel={hideEditForm}
        />
      )}
        <Table className="Register-table" columns={columns} dataSource={data}  scroll={{ x: true }}/>
    </>
  );
};

export default Registered;
