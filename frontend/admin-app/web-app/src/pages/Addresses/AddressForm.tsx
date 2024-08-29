
import React, { useState, useEffect } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import api from '../../api';

interface Address {
  addressID: number;
  name: string;
  street: string;
  areaID: number;
  cityID: number;
  state: string;
  postalCode: string;
  countryID: number;
  latitude: number;
  longitude: number;
  createdBy: number;
  createdAt: string;
  updatedBy: number;
  updatedAt: string;
}

interface Country {
  countryID: number;
  countryName: string;
}

interface City {
  cityID: number;
  cityName: string;
}

interface Area {
  areaID: number;
  areaName: string;
}

const initialFormData: Partial<Address> = {
  addressID: 0,
  name: '',
  street: '',
  areaID: 0,
  cityID: 0,
  state: '',
  postalCode: '',
  countryID: 0,
  latitude: 0,
  longitude: 0,
  createdBy: 0,
  createdAt: new Date().toISOString(),
  updatedBy: 0,
  updatedAt: new Date().toISOString(),
};

const AddressForm = () => {
  const { id } = useParams();
  const [formData, setFormData] = useState<Partial<Address>>(initialFormData);
  const [countries, setCountries] = useState<Country[]>([]);
  const [cities, setCities] = useState<City[]>([]);
  const [areas, setAreas] = useState<Area[]>([]);
  const [alert, setAlert] = useState<{ type: 'success' | 'error', message: string } | null>(null);
  const navigate = useNavigate();

  useEffect(() => {
    const fetchAddress = async () => {
      if (id) {
        try {
          const response = await api.get(`/Addresses/${id}`);
          const addressData = response.data;
          setFormData(addressData);

          // Fetch cities and areas based on IDs
          if (addressData.countryID) {
            fetchCities(addressData.countryID);
          }
          if (addressData.cityID) {
            fetchAreas(addressData.cityID);
          }
        } catch (error) {
          console.error('Error fetching address data:', error);
        }
      }
    };

    fetchAddress();
  }, [id]);

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

  const fetchCities = async (countryID: number) => {
    if (countryID) {
      try {
        const response = await api.get(`/Cities?countryID=${countryID}`);
        setCities(response.data);
      } catch (error) {
        console.error('Error fetching cities:', error);
      }
    } else {
      setCities([]);
    }
  };

  const fetchAreas = async (cityID: number) => {
    if (cityID) {
      try {
        const response = await api.get(`/Areas?cityID=${cityID}`);
        setAreas(response.data);
      } catch (error) {
        console.error('Error fetching areas:', error);
      }
    } else {
      setAreas([]);
    }
  };

  const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLSelectElement>) => {
    const { name, value } = e.target;
    setFormData({
      ...formData,
      [name]: value,
    });
  };

  const handleCountryChange = (e: React.ChangeEvent<HTMLSelectElement>) => {
    const selectedCountryID = Number(e.target.value);
    setFormData({ ...formData, countryID: selectedCountryID });
    fetchCities(selectedCountryID);
    setFormData({ ...formData, cityID: 0, areaID: 0 }); // Reset city and area when country changes
  };

  const handleCityChange = (e: React.ChangeEvent<HTMLSelectElement>) => {
    const selectedCityID = Number(e.target.value);
    setFormData({ ...formData, cityID: selectedCityID });
    fetchAreas(selectedCityID);
    setFormData({ ...formData, areaID: 0 }); // Reset area when city changes
  };

  const handleAreaChange = (e: React.ChangeEvent<HTMLSelectElement>) => {
    const selectedAreaID = Number(e.target.value);
    setFormData({ ...formData, areaID: selectedAreaID });
  };

  const handleSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    try {
      if (id) {
        await api.put(`/Addresses/${formData.addressID}`, formData);
        setAlert({ type: 'success', message: 'Address updated successfully!' });
      } else {
        const response = await api.post('/Addresses', formData);
        setFormData(response.data);
        setAlert({ type: 'success', message: 'Address created successfully!' });
      }

      setFormData(initialFormData);
      navigate('/address');
    } catch (error) {
      console.error('Error saving address:', error);
      setAlert({ type: 'error', message: 'Error saving address. Please try again later.' });
    }
  };

  const handleBackClick = () => {
    navigate('/address');
  };

  return (
    <div className="rounded-sm border border-stroke bg-white shadow-default dark:border-strokedark dark:bg-boxdark">
      <div className="border-b border-stroke py-4 px-6.5 dark:border-strokedark flex justify-between items-center">
        <h3 className="font-medium text-black dark:text-white">
          {id ? 'Update Address' : 'Create Address'}
        </h3>
        <button
          onClick={handleBackClick}
          className="bg-secondary text-white py-2 px-4 rounded-lg hover:bg-opacity-90"
        >
          Back
        </button>
      </div>

      {alert && (
        <div className={`mt-4 mx-6.5 ${alert.type === 'success' ? 'text-green-700 bg-green-100' : 'text-red-700 bg-red-100'} py-2 px-4 rounded-lg`}>
          {alert.message}
        </div>
      )}

      <form onSubmit={handleSubmit} className="flex flex-col gap-5.5 p-6.5">
        <div>
          <label htmlFor="name" className="mb-3 block text-black dark:text-white">
            Name
          </label>
          <input
            type="text"
            id="name"
            name="name"
            value={formData.name || ''}
            onChange={handleChange}
            required
            className="w-full rounded-lg border-[1.5px] border-stroke bg-transparent py-3 px-5 text-black outline-none transition focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter dark:border-form-strokedark dark:bg-form-input dark:text-white dark:focus:border-primary"
          />
        </div>

        <div>
          <label htmlFor="countryName" className="mb-3 block text-black dark:text-white">
            Country
          </label>
          <select
            id="countryName"
            name="countryID"
            value={formData.countryID || ''}
            onChange={handleCountryChange}
            required
            className="w-full rounded-lg border-[1.5px] border-stroke bg-transparent py-3 px-5 text-black outline-none transition focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter dark:border-form-strokedark dark:bg-form-input dark:text-white dark:focus:border-primary"
          >
            <option value="">Select a country</option>
            {countries.map((country) => (
              <option key={country.countryID} value={country.countryID}>
                {country.countryName}
              </option>
            ))}
          </select>
        </div>

        <div>
          <label htmlFor="state" className="mb-3 block text-black dark:text-white">
            State
          </label>
          <select
            id="state"
            name="state"
            value={formData.state || ''}
            onChange={handleChange}
            required
            className="w-full rounded-lg border-[1.5px] border-stroke bg-transparent py-3 px-5 text-black outline-none transition focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter dark:border-form-strokedark dark:bg-form-input dark:text-white dark:focus:border-primary"
          >
            <option value="">Select a state</option>
            <option value="Punjab">Punjab</option>
            <option value="Sindh">Sindh</option>
            <option value="Balochistan">Balochistan</option>
            <option value="KPK">KPK</option>
          </select>
        </div>

        <div>
          <label htmlFor="cityName" className="mb-3 block text-black dark:text-white">
            City
          </label>
          <select
            id="cityName"
            name="cityID"
            value={formData.cityID || ''}
            onChange={handleCityChange}
            required
            className="w-full rounded-lg border-[1.5px] border-stroke bg-transparent py-3 px-5 text-black outline-none transition focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter dark:border-form-strokedark dark:bg-form-input dark:text-white dark:focus:border-primary"
          >
            <option value="">Select a city</option>
            {cities.map((city) => (
              <option key={city.cityID} value={city.cityID}>
                {city.cityName}
              </option>
            ))}
          </select>
        </div>

        <div>
          <label htmlFor="areaName" className="mb-3 block text-black dark:text-white">
            Area
          </label>
          <select
            id="areaName"
            name="areaID"
            value={formData.areaID || ''}
            onChange={handleAreaChange}
            required
            className="w-full rounded-lg border-[1.5px] border-stroke bg-transparent py-3 px-5 text-black outline-none transition focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter dark:border-form-strokedark dark:bg-form-input dark:text-white dark:focus:border-primary"
          >
            <option value="">Select an area</option>
            {areas.map((area) => (
              <option key={area.areaID} value={area.areaID}>
                {area.areaName}
              </option>
            ))}
          </select>
        </div>

        <div>
          <label htmlFor="street" className="mb-3 block text-black dark:text-white">
            Street
          </label>
          <input
            type="text"
            id="street"
            name="street"
            value={formData.street || ''}
            onChange={handleChange}
            required
            className="w-full rounded-lg border-[1.5px] border-stroke bg-transparent py-3 px-5 text-black outline-none transition focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter dark:border-form-strokedark dark:bg-form-input dark:text-white dark:focus:border-primary"
          />
        </div>

        <div>
          <label htmlFor="postalCode" className="mb-3 block text-black dark:text-white">
            Postal Code
          </label>
          <input
            type="text"
            id="postalCode"
            name="postalCode"
            value={formData.postalCode || ''}
            onChange={handleChange}
            required
            className="w-full rounded-lg border-[1.5px] border-stroke bg-transparent py-3 px-5 text-black outline-none transition focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter dark:border-form-strokedark dark:bg-form-input dark:text-white dark:focus:border-primary"
          />
        </div>
        <div>
          <label htmlFor="latitude" className="mb-3 block text-black dark:text-white">
            Latitude
          </label>
          <input
            type="text"
            id="latitude"
            name="latitude"
            value={formData.latitude || ''}
            onChange={handleChange}
            className="w-full rounded-lg border-[1.5px] border-stroke bg-transparent py-3 px-5 text-black outline-none transition focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter dark:border-form-strokedark dark:bg-form-input dark:text-white dark:focus:border-primary"
          />
        </div>

        <div>
          <label htmlFor="longitude" className="mb-3 block text-black dark:text-white">
            Longitude
          </label>
          <input
            type="text"
            id="longitude"
            name="longitude"
            value={formData.longitude || ''}
            onChange={handleChange}
            className="w-full rounded-lg border-[1.5px] border-stroke bg-transparent py-3 px-5 text-black outline-none transition focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter dark:border-form-strokedark dark:bg-form-input dark:text-white dark:focus:border-primary"
          />
        </div>

      


        <div className="flex justify-end gap-4">
          <button
            type="button"
            onClick={handleBackClick}
            className="bg-secondary text-white py-2 px-4 rounded-lg hover:bg-opacity-90"
          >
            Back
          </button>
          <button
            type="submit"
            className="bg-primary text-white py-2 px-4 rounded-lg hover:bg-opacity-90"
          >
            {id ? 'Update Address' : 'Create Address'}
          </button>
        </div>
      </form>
    </div>
  );
};

export default AddressForm;

