import React, { useEffect, useState } from 'react';
import api from '../../api';

interface AreaDropdownProps {
  selectedCity?: string;
  selectedArea?: string;
  onAreaChange: (area: string) => void;
}

const AreaDropdown: React.FC<AreaDropdownProps> = ({ selectedCity, selectedArea, onAreaChange }) => {
  const [areas, setAreas] = useState<string[]>([]);
  const [selected, setSelected] = useState<string>(selectedArea || '');

  useEffect(() => {
    if (selectedCity) {
      const fetchAreas = async () => {
        try {
          const response = await api.get(`/Areas?city=${selectedCity}`);
          setAreas(response.data);
        } catch (error) {
          console.error('Error fetching areas:', error);
        }
      };

      fetchAreas();
    }
  }, [selectedCity]);

  useEffect(() => {
    setSelected(selectedArea || '');
  }, [selectedArea]);

  const handleChange = (e: React.ChangeEvent<HTMLSelectElement>) => {
    const value = e.target.value;
    setSelected(value);
    onAreaChange(value);
  };

  return (
    <select
      value={selected}
      onChange={handleChange}
      className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm"
    >
      <option value="">Select an area</option>
      {areas.map((area, index) => (
        <option key={index} value={area}>
          {area}
        </option>
      ))}
    </select>
  );
};

export default AreaDropdown;
