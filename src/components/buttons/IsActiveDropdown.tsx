import React from 'react';
import { Select } from 'antd';

const { Option } = Select;

interface StatusDropdownProps {
  value: any;
  onChange: (value: any) => void;
}

const IsActiveDropdown: React.FC<StatusDropdownProps> = ({ value, onChange }) => {
  return (
    <Select value={value} onChange={onChange}>
      <Option value={true}>Active</Option>
      <Option value={false}>Inactive</Option>
    </Select>
  );
};

export default IsActiveDropdown;
