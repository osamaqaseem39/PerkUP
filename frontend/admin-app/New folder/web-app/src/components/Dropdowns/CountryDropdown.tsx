import React, { useEffect, useState } from 'react';
import api from '../../api';

interface CountryDropdownProps {
  selectedCountry?: string;
  onCountryChange: (country: string) => void;
}

const CountryDropdown: React.FC<CountryDropdownProps> = ({ selectedCountry, onCountryChange }) => {
  const [countries, setCountries] = useState<{ id: number, name: string }[]>([]);

  useEffect(() => {
    const fetchCountries = async () => {
      try {
        const response = await api.get('/Countries');
        setCountries(response.data);
      } catch (error) {
        console.error('Error fetching countries:', error);
      }
    };

    fetchCountries();
  }, []);

  return (
    <select
      value={selectedCountry}
      onChange={(e) => onCountryChange(e.target.value)}
      className="border rounded p-2"
    >
      <option value="">Select a country</option>
      {countries.map((country) => (
        <option key={country.id} value={country.id}>
          {country.name}
        </option>
      ))}
    </select>
  );
};

export default CountryDropdown;
