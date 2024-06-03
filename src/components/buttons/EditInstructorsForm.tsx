import React, { useEffect, useState } from 'react';
import { Modal, Form, Input, Select } from 'antd';
import StatusDropdown from './IsActiveDropdown';

interface EditInstructorsFormProps {
  visible: boolean;
  initialValues: any;
  onUpdate: (values: any) => void;
  onCancel: () => void;
}

const EditInstructorsForm: React.FC<EditInstructorsFormProps> = ({ visible, initialValues, onUpdate, onCancel }) => {
  const [form] = Form.useForm();
  const [showPosteInput, setShowPosteInput] = useState(false);
  const [showExpertiseInput, setShowExpertiseInput] = useState(false);

  useEffect(() => {
    form.setFieldsValue({
      name: initialValues.name,
      email: initialValues.email,
      password: initialValues.password,
      IsActive: initialValues.IsActive,
    });
  }, [initialValues]);

  const onFinish = (values: any) => {
    const updatedValues = { ...initialValues, ...values, _id: initialValues._id };
    if (updatedValues.Expertise === 'other') {
      updatedValues.Expertise = values.otherExpertise;
    }
    if (updatedValues.Poste === 'other') {
      updatedValues.Poste = values.otherPoste;
    }
    onUpdate(updatedValues);
  };
  

  const handlePosteChange = (value: string) => {
    setShowPosteInput(value === 'other');
  };

  const handleExpertiseChange = (value: string) => {
    setShowExpertiseInput(value === 'other');
  };
  

  return (
    <Modal
      visible={visible}
      title="Edit Instructors"
      okText="Save"
      cancelText="Cancel"
      onCancel={onCancel}
      onOk={() => {
        form.validateFields().then((values) => {
          onFinish(values);
          form.resetFields();
        });
      }}
    >
      <Form form={form} layout="vertical" initialValues={initialValues}>
        <Form.Item
          name="name"
          label="Name"
          rules={[{ required: true, message: 'Please enter the name' }]}
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
        <Form.Item
          name="Poste"
          label="Poste"
          rules={[{ required: true, message: 'Please select or enter the poste' }]}
        >
          <Select onChange={handlePosteChange}>
            <Select.Option value="doctor">Doctor</Select.Option>
            <Select.Option value="medical">Medical</Select.Option>
            <Select.Option value="educational">Educational</Select.Option>
            <Select.Option value="other">Other</Select.Option>
          </Select>
        </Form.Item>
        {showPosteInput && (
          <Form.Item name="otherPoste" label="Other Poste">
            <Input />
          </Form.Item>
        )}
        <Form.Item
          name="Expertise"
          label="Expertise"
          rules={[{ required: true, message: 'Please select or enter the expertise' }]}
        >
          <Select onChange={handleExpertiseChange}>
            <Select.Option value="medical">Medical</Select.Option>
            <Select.Option value="other">Other</Select.Option>
          </Select>
        </Form.Item>
        {showExpertiseInput && (
          <Form.Item name="otherExpertise" label="Other Expertise">
            <Input />
          </Form.Item>
        )}
        <Form.Item
          name="isActive"
          label="isActive"
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

export default EditInstructorsForm;
