import React, { useState, useEffect } from 'react';
import { Table, Input, Button, Space, Modal, message } from 'antd';
import { SearchOutlined } from '@ant-design/icons';
import Highlighter from 'react-highlight-words';
import { ColumnType } from 'antd/es/table';
import { Key } from 'react';
import { CheckCircleOutlined, CloseCircleOutlined } from '@ant-design/icons';
import { DeleteOutlined, EditOutlined } from '@ant-design/icons';
import axios from 'axios'; // Import axios for making HTTP requests
import './Instructors.css';
import AddInstructorsForm from '../../buttons/AddInstructors';
import EditInstructorsForm from '../../buttons/EditInstructorsForm';

interface DataItem {
  _id: number;
  name: string;
  Expertise: string;
  Poste: string;
  email: string;
  password: string;
  isActive: boolean;
  ActivationCode: string;
}

const Instructors: React.FC = () => {
  const [searchText, setSearchText] = useState<string>('');
  const [searchedColumn, setSearchedColumn] = useState<string>('');
  const [isAddFormVisible, setAddFormVisible] = useState(false);
  const [isEditFormVisible, setEditFormVisible] = useState(false);
  const [editRecord, setEditRecord] = useState<any>(null); // State to store the record being edited
  const [data, setData] = useState<DataItem[]>([]); // State variable for storing data fetched from API

  useEffect(() => {
    // Fetch data from API when component mounts
    axios.get('http://localhost:3002/api/formater')
      .then(response => {
        setData(response.data as DataItem[]);
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
  
  const showEditForm = (record: any) => {
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
        axios.delete(`http://localhost:3002/deleteformater`, { data: { _id: record._id } })
          .then(response => {
            // If deletion is successful, update the local state by removing the deleted record
            if (response.status === 200) {
              const newData = data.filter(item => item._id !== record._id);
              setData(newData);
              message.success(response.data.message);
            } else {
              message.error('Failed to delete formater');
            }
          })
          .catch(error => {
            console.error(error);
            message.error('Failed to delete formater');
          });
      },
      onCancel: () => {
        console.log('Delete canceled');
      },
    });
  };
  
  
  const onUpdate = (updatedValues: any) => {
    // If the selected value is "other", use the value from the "otherPoste" field
    const posteToUpdate = updatedValues.Poste === 'other' ? updatedValues.otherPoste : updatedValues.Poste;
  
    const postData = {
      ...updatedValues,
      Poste: posteToUpdate
    };
  
    axios.put(`http://localhost:3002/updateformater`, postData)
      .then(response => {
        if (response.status === 200) {
          // If update is successful, update the local state with the updated record
          const newData = data.map(item => {
            if (item._id === updatedValues._id) {
              return { ...item, ...updatedValues };
            }
            return item;
          });
          setData(newData);
          message.success(response.data.message);
        } else {
          message.error('Failed to update formater');
        }
      })
      .catch(error => {
        console.error(error);
        message.error('Failed to update formater');
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
    
    onFilter: (value: any, record: DataItem) =>
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
  const handleAddInstructor = (values: any) => {
    axios.post('http://localhost:3002/addformater', values)
      .then(response => {
        // If addition is successful, update the local state with the added record
        if (response.status === 200) {
          const newData = [...data, response.data];
          setData(newData);
          message.success('Instructor added successfully');
          hideAddForm();
        } else {
          message.error('Failed to add instructor');
        }
      })
      .catch(error => {
        console.error(error);
        message.error('Failed to add instructor');
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
      title: 'Expertise',
      dataIndex: 'Expertise',
      key: 'Expertise',
      align: 'center',
      sorter: (a, b) => a.Expertise.localeCompare(b.Expertise),
      ...getColumnSearchProps('Expertise'),
    },
    {
        title: 'Poste',
        dataIndex: 'Poste',
        key: 'Poste',
        align: 'center',
        sorter: (a, b) => a.Poste.localeCompare(b.Poste),
        ...getColumnSearchProps('Poste'),
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
            <EditOutlined
              style={{ color: 'green', cursor: 'pointer' }}
              onClick={() => showEditForm(record)}
            />
            <DeleteOutlined
              style={{ color: 'red', cursor: 'pointer' }}
              onClick={() => handleDelete(record)}
            />
          </Space>
        ),
      },
    ];
  
    return (
      <>
        <Button type="primary" style={{ marginBottom: 16 ,background: '#972929' }}onClick={showAddForm}>
          Add Instructors
        </Button>
        <AddInstructorsForm
  visible={isAddFormVisible}
  onCreate={handleAddInstructor}
  onCancel={hideAddForm}
/>

  
        {isEditFormVisible && editRecord && (
          <EditInstructorsForm
            visible={isEditFormVisible}
            initialValues={editRecord}
            onUpdate={onUpdate}
            onCancel={hideEditForm}
          />
        )}
        <Table className="Instructors-table" columns={columns} dataSource={data} scroll={{ x: true }}/>
      </>
    );
  };
  
  export default Instructors;
  
