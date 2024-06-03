import React from 'react';
import { Modal, Form, Input, Button, DatePicker, TimePicker } from 'antd';
import StatusDropdown from './StatusDropdown';
import LectureHallDropdown from './LectureHallDropdown';

interface AddCourseFormProps {
  visible: boolean;
  onCreate: (values: any) => void;
  onCancel: () => void;
}

const AddCourseForm: React.FC<AddCourseFormProps> = ({ visible, onCreate, onCancel }) => {
  const [form] = Form.useForm();

  const onFinish = (values: any) => {
    onCreate(values);
    form.resetFields();
  };

  return (
    <Modal
      visible={visible}
      title="Add Course"
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
          name="Prof"
          label="Prof"
          rules={[{ required: true, message: 'Please enter the instructor name' }]}
        >
          <Input />
        </Form.Item>
        <Form.Item
          label="category"
          name="category"
          rules={[{ required: true, message: 'Please enter the category!' }]}
        >
          <Input />
        </Form.Item>
        <Form.Item
          label="description"
          name="description"
          rules={[{ required: true, message: 'Please enter the description!' }]}
        >
          <Input />
        </Form.Item>
        <Form.Item
          label="Time of Start"
          name="Timeofstart"
          rules={[{ required: true, message: 'Please select the time of start!' }]}
        >
          <TimePicker style={{ width: '100%' }} format="HH:mm" />
        </Form.Item>

        <Form.Item
          label="Time of End"
          name="Timeofend"
          rules={[{ required: true, message: 'Please select the time of end!' }]}
        >
          <TimePicker style={{ width: '100%' }} format="HH:mm" />
        </Form.Item>

        <Form.Item
          label="Date"
          name="Date"
          rules={[{ required: true, message: 'Please select the date!' }]}
        >
          <DatePicker style={{ width: '100%' }} format="DD/MM/YYYY" />
        </Form.Item>

        <Form.Item
          label="Lecture Hall"
          name="Salle"
          rules={[{ required: true, message: 'Please select the lecture hall!' }]}
        >
          <LectureHallDropdown onChange={(value) => form.setFieldsValue({ lectureHall: value })} />
        </Form.Item>

        <Form.Item
          label="price"
          name="price"
          rules={[{ required: true, message: 'Please enter the price!' }]}
        >
          <Input />
        </Form.Item>

        <Form.Item
          label="Tel Number"
          name="Tel"
          rules={[{ required: true, message: 'Please enter the telephone number!' }]}
        >
          <Input />
        </Form.Item>

        <Form.Item
          label="status"
          name="status"
          rules={[{ required: true, message: 'Please select the status!' }]}
        >
          <StatusDropdown onChange={(value) => form.setFieldsValue({ status: value })} />
        </Form.Item>
      </Form>
    </Modal>
  );
};

export default AddCourseForm;
