import React, { useState, useEffect } from 'react';
import { Table, Input, Button, Space, Modal, message } from 'antd';
import { SearchOutlined } from '@ant-design/icons';
import Highlighter from 'react-highlight-words';
import { ColumnType } from 'antd/es/table';
import { CheckCircleOutlined, CloseCircleOutlined, DeleteOutlined, EditOutlined } from '@ant-design/icons';
import './learners.css';
import EditLearnersForm from '../../buttons/EditLearnersForm';
import AddLearnersForm from '../../buttons/AddLearnersForm';
import axios from 'axios';

interface DataItem {
  _id: number;
  name: string;
  cin: string;
  email: string;
  password: string;
  isActive: boolean;
  ActivationCode: string;
}

const Learners: React.FC = () => {
  const [searchText, setSearchText] = useState<string>('');
  const [searchedColumn, setSearchedColumn] = useState<string>('');
  const [isAddFormVisible, setAddFormVisible] = useState(false);
  const [isEditFormVisible, setEditFormVisible] = useState(false);
  const [editRecord, setEditRecord] = useState<DataItem | null>(null);
  const [data, setData] = useState<DataItem[]>([]);

  useEffect(() => {
    // Fetch data from the API
    axios.get<DataItem[]>('http://localhost:3002/api/users')
      .then(response => {
        setData(response.data);
      })
      .catch(error => {
        console.error(error);
      });
  }, []);

  const showAddForm = () => {
    setAddFormVisible(true);
  };

  const hideAddForm = () => {
    setAddFormVisible(false);
  };

  const showEditForm = (record: DataItem) => {
    setEditRecord(record);
    setEditFormVisible(true);
  };

  const hideEditForm = () => {
    setEditFormVisible(false);
    setEditRecord(null); // Reset the edit record
  };

  const handleDelete = (record: DataItem) => {
    Modal.confirm({
      title: 'Confirm Delete',
      content: 'Are you sure you want to delete this record?',
      onOk: () => {
        axios.delete(`http://localhost:3002/deleteuser`, {
          data: { _id: record._id } // Pass _id of the record to delete
        })
          .then(response => {
            // If deletion is successful, update the local state by removing the deleted record
            setData(prevData => prevData.filter(item => item._id !== record._id));
            message.success(response.data.message);
          })
          .catch(error => {
            console.error(error);
            message.error('Failed to delete user');
          });
      },
      onCancel: () => {
        console.log('Delete canceled');
      },
    });
  };
  
  const onUpdate = (updatedValues: DataItem) => {
    axios.put(`http://localhost:3002/updateuser`, updatedValues)
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
      })
      .catch(error => {
        console.error(error);
        message.error('Failed to update user');
      });
  };
  
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
  
    onFilter: (value: any, record: any) =>
      record[dataIndex].toString().toLowerCase().includes(value?.toString().toLowerCase() || ''),
  
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
  

  const handleSearch = (selectedKeys: React.Key[], confirm: () => void, dataIndex: string) => {
    confirm();
    setSearchText(selectedKeys[0] as string);
    setSearchedColumn(dataIndex);
  };

  const handleReset = (clearFilters?: () => void) => {
    if (clearFilters) {
      clearFilters();
    }
    setSearchText('');
  };
  const handleAddLearner = (values: any) => {

    axios.post('http://localhost:3002/addlearner', values)
      .then(response => {
        console.log('Add learner API response:', response.data);
        message.success('Learner added successfully');
        hideAddForm();
      })
      .catch(error => {
        console.error('Error adding learner:', error);
        if (error.response && error.response.data && error.response.data.message) {
          // Handle specific error messages from the backend
          message.error(error.response.data.message);
        } else {
          message.error('Failed to add learner');
        }
      });
  };
  

  const columns: ColumnType<DataItem>[] = [
    {
      title: 'ID',
      dataIndex: '_id',
      key: '_id',
      align: 'center',
      sorter: (a, b) => a._id - b._id,
      ...getColumnSearchProps('_id'),
    },
    
    {
      title: 'Name',
      dataIndex: 'name',
      key: 'name',
      align: 'center',
      sorter: (a, b) => a.name.localeCompare(b.name),
      ...getColumnSearchProps('name'),
    },
    
    {
      title: 'CIN',
      dataIndex: 'cin',
      key: 'cin',
      align: 'center',
      sorter: (a, b) => a.cin.localeCompare(b.cin),
      ...getColumnSearchProps('cin'),
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
      title: 'Password',
      dataIndex: 'password',
      key: 'password',
      align: 'center',
      sorter: (a, b) => a.password.localeCompare(b.password),
    },
    {
      title: 'IsActive',
      dataIndex: 'isActive',
      key: 'isActive',
      align: 'center',
      render: (isActive: boolean) => (
        <span style={{ color: isActive ? 'green' : 'red' }}>
          {isActive ? <CheckCircleOutlined /> : <CloseCircleOutlined />}
        </span>
      ),
      sorter: (a, b) => (a.isActive ? 1 : -1) - (b.isActive ? 1 : -1),
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
      <Button type="primary" style={{ marginBottom: 16, background: '#972929' }} onClick={showAddForm}>
        Add learners
      </Button>

      <AddLearnersForm
        visible={isAddFormVisible}
        onCreate={handleAddLearner}
        onCancel={hideAddForm}
      />

      {isEditFormVisible && editRecord && (
        <EditLearnersForm
          visible={isEditFormVisible}
          initialValues={editRecord}
          onUpdate={onUpdate}
          onCancel={hideEditForm}
        />
      )}

      <Table className="learners-table" columns={columns} dataSource={data} scroll={{ x: true }}/>
    </>
  );
};


export default Learners;

