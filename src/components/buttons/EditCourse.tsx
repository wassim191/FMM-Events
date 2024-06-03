import React, { useState, useEffect } from 'react';
import { Modal, Form, Input, DatePicker, TimePicker, message } from 'antd';
import StatusDropdown from '../buttons/StatusDropdown';
import LectureHallDropdown from '../buttons/LectureHallDropdown';
import moment from 'moment';

interface EditCourseProps {
  visible: boolean;
  initialValues: any; // Pass existing values to prefill the form
  onUpdate: (values: any) => void;
  onCancel: () => void;
}

const EditCourse: React.FC<EditCourseProps> = ({ visible, initialValues, onUpdate, onCancel }) => {
  const [form] = Form.useForm();

  useEffect(() => {
    form.setFieldsValue({
      Prof: initialValues.Prof,
      category: initialValues.category,
      description: initialValues.description,
      Time: moment(initialValues.Time),
      timeofend: moment(initialValues.timeofend),
      Date: moment(initialValues.Date),
      Salle: initialValues.Salle,
      Tel: initialValues.Tel,
      status: initialValues.status,
      email: initialValues.status,
    });
  }, [initialValues, form]);

  const onFinish = (values: any) => {
    const updatedValues = { ...initialValues, ...values, _id: initialValues._id };
    onUpdate(updatedValues);
  };

  return (
    <Modal
      visible={visible}
      title="Edit Course"
      okText="Save"
      cancelText="Cancel"
      onCancel={onCancel}
      onOk={() => {
        form.validateFields().then((values) => {
          onFinish(values);
          form.resetFields();
        }).catch(error => {
          console.error('Error during form validation:', error);
          message.error('Please fill in all required fields');
        });
      }}
    >
      <Form form={form} layout="vertical" initialValues={initialValues}>
        <Form.Item
          name="Prof"
          label="Instructor Name"
          rules={[{ required: true, message: 'Please enter the instructor name' }]}
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
          label="Category"
          name="category"
          rules={[{ required: true, message: 'Please enter the category!' }]}
        >
          <Input />
        </Form.Item>
        <Form.Item
          label="Description"
          name="description"
          rules={[{ required: true, message: 'Please enter the description!' }]}
        >
          <Input />
        </Form.Item>
        <Form.Item
          label="Time of Start"
          name="Time"
          rules={[{ required: true, message: 'Please select the time of start!' }]}
        >
          <TimePicker style={{ width: '100%' }} format="HH:mm" />
        </Form.Item>

        <Form.Item
          label="Time of End"
          name="timeofend"
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
          <LectureHallDropdown onChange={(value) => form.setFieldsValue({ Salle: value })} />
        </Form.Item>

        <Form.Item
          label="Tel Number"
          name="Tel"
          rules={[{ required: true, message: 'Please enter the telephone number!' }]}
        >
          <Input />
        </Form.Item>

        <Form.Item
          label="Status"
          name="status"
          rules={[{ required: true, message: 'Please select the status!' }]}
        >
          <StatusDropdown onChange={(value) => form.setFieldsValue({ status: value })} />
        </Form.Item>
      </Form>
    </Modal>
  );
};

export default EditCourse;
