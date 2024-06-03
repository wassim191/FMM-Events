import React, { useState } from 'react';
import { Modal, Form, Input, Select } from 'antd';
import StatusDropdown from './IsActiveDropdown';
const { Option } = Select;

interface AddInstructorsFormProps {
  visible: boolean;
  onCreate: (values: any) => void;
  onCancel: () => void;
}

const AddInstructorsForm: React.FC<AddInstructorsFormProps> = ({ visible, onCreate, onCancel }) => {
  const [form] = Form.useForm();
  const [showOtherExpertise, setShowOtherExpertise] = useState<boolean>(false);
  const [showOtherPoste, setShowOtherPoste] = useState<boolean>(false);

  const handleExpertiseChange = (value: string) => {
    setShowOtherExpertise(value === 'other');
  };

  const handlePosteChange = (value: string) => {
    setShowOtherPoste(value === 'other');
  };

  const onFinish = (values: any) => {
    const updatedValues = { ...values };
    if (values.Expertise === 'other') {
      updatedValues.Expertise = values.otherExpertise;
    }
    if (values.Poste === 'other') {
      updatedValues.Poste = values.otherPoste;
    }
    onCreate(updatedValues);
    form.resetFields();
  };

  return (
    <Modal
      visible={visible}
      title="Add Instructors"
      okText="Add"
      cancelText="Cancel"
      onCancel={onCancel}
      onOk={() => {
        form.validateFields().then((values) => {
          onFinish(values);
        });
      }}
    >
      <Form form={form} layout="vertical">
        <Form.Item
          name="name"
          label="Name"
          rules={[{ required: true, message: 'Please enter the username' }]}
        >
          <Input />
        </Form.Item>
        <Form.Item
          name="email"
          label="Email"
          rules={[{ required: true, message: 'Please enter the Email' }]}
        >
          <Input />
        </Form.Item>
        <Form.Item
          name="password"
          label="Password"
          rules={[{ required: true, message: 'Please enter the Password' }]}
        >
          <Input />
        </Form.Item>
        <Form.Item name="Poste" label="Poste" rules={[{ required: true, message: 'Please select the poste' }]}>
          <Select
            showSearch
            placeholder="Select a poste"
            optionFilterProp="children"
            onChange={handlePosteChange}
          >
            <Option value="doctor">Doctor</Option>
            <Option value="medical">Medical</Option>
            <Option value="educational">Educational</Option>
            <Option value="other">Other</Option>
          </Select>
        </Form.Item>
        {showOtherPoste && (
          <Form.Item name="otherPoste" label="Other Poste">
            <Input />
          </Form.Item>
        )}

        <Form.Item name="Expertise" label="Expertise" rules={[{ required: true, message: 'Please select the expertise' }]}>
          <Select
            showSearch
            placeholder="Select an expertise"
            optionFilterProp="children"
            onChange={handleExpertiseChange}
          >
            <Option value="medical">Medical</Option>
            <Option value="other">Other</Option>
          </Select>
        </Form.Item>
        {showOtherExpertise && (
          <Form.Item name="otherExpertise" label="Other Expertise">
            <Input />
          </Form.Item>
        )}

        <Form.Item
          name="isActive"
          label="Is Active"
          rules={[{ required: true, message: 'Please select the status' }]}
        >
          <StatusDropdown
            value={form.getFieldValue('isActive')}
            onChange={(value) => form.setFieldsValue({ isActive: value })}
          />
        </Form.Item>
      </Form>
    </Modal>
  );
};

export default AddInstructorsForm;
