import React, { useEffect, useState } from 'react';
import api from '../../api';

interface CityDropdownProps {
  selectedCountry?: string;
  selectedCity?: string;
  onCityChange: (city: string) => void;
}

const CityDropdown: React.FC<CityDropdownProps> = ({ selectedCountry, selectedCity, onCityChange }) => {
  const [cities, setCitys] = useState<string[]>([]);
  const [selected, setSelected] = useState<string>(selectedCity || '');

  useEffect(() => {
    if (selectedCountry) {
      const fetchCitys = async () => {
        try {
          const response = await api.get(`/Citys?country=${selectedCountry}`);
          setCitys(response.data);
        } catch (error) {
          console.error('Error fetching cities:', error);
        }
      };

      fetchCitys();
    }
  }, [selectedCountry]);

  useEffect(() => {
    setSelected(selectedCity || '');
  }, [selectedCity]);

  const handleChange = (e: React.ChangeEvent<HTMLSelectElement>) => {
    const value = e.target.value;
    setSelected(value);
    onCityChange(value);
  };

  return (
    <select
      value={selected}
      onChange={handleChange}
      className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm"
    >
      <option value="">Select an city</option>
      {cities.map((city, index) => (
        <option key={index} value={city}>
          {city}
        </option>
      ))}
    </select>
  );
};

export default CityDropdown;
