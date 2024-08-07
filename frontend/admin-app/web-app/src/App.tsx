import { useEffect, useState } from 'react';
import { Route, Routes, useLocation } from 'react-router-dom';

import Loader from './common/Loader';
import PageTitle from './components/PageTitle';
import SignIn from './pages/Authentication/SignIn';
import SignUp from './pages/Authentication/SignUp';
import Calendar from './pages/Calendar';
import Chart from './pages/Chart';
import ECommerce from './pages/Dashboard/ECommerce';
import FormElements from './pages/Form/FormElements';
import FormLayout from './pages/Form/FormLayout';
import Profile from './pages/Profile';
import Settings from './pages/Settings';
import Tables from './pages/Tables';
import Alerts from './pages/UiElements/Alerts';
import Buttons from './pages/UiElements/Buttons';
import DefaultLayout from './layout/DefaultLayout';
import CountryForm from './pages/Countries/CountryForm';
import CountryList from './pages/Countries/CountryList';
import CityForm from './pages/Cities/CityForm';
import CityList from './pages/Cities/CityList';
import AreaForm from './pages/Areas/AreaForm';
import AreaList from './pages/Areas/AreaList';

import AddressForm from './pages/Addresses/AddressForm';
import AddressList from './pages/Addresses/AddressList';

function App() {
  const [loading, setLoading] = useState<boolean>(true);
  const { pathname } = useLocation();

  useEffect(() => {
    window.scrollTo(0, 0);
  }, [pathname]);

  useEffect(() => {
    setTimeout(() => setLoading(false), 1000);
  }, []);

  return loading ? (
    <Loader />
  ) : (
    <Routes>
      {/* Authentication Routes */}
      <Route
        path="/"
        element={
          <>
            <PageTitle title="Signin | TailAdmin - Tailwind CSS Admin Dashboard Template" />
            <SignIn />
          </>
        }
      />
      <Route
        path="/auth/signup"
        element={
          <>
            <PageTitle title="Signup | TailAdmin - Tailwind CSS Admin Dashboard Template" />
            <SignUp />
          </>
        }
      />

      {/* Dashboard Routes */}
      <Route
        path="/dashboard"
        element={
          <DefaultLayout>
            <PageTitle title="Dashboard" />
            <ECommerce />
          </DefaultLayout>
        }
      />
      <Route
        path="/calendar"
        element={
          <DefaultLayout>
            <PageTitle title="Calendar" />
            <Calendar />
          </DefaultLayout>
        }
      />
      <Route
        path="/profile"
        element={
          <DefaultLayout>
            <PageTitle title="Profile | TailAdmin - Tailwind CSS Admin Dashboard Template" />
            <Profile />
          </DefaultLayout>
        }
      />
       <Route
        path="/countryform"
        element={
          <DefaultLayout>
            <PageTitle title="Country Form" />
            <CountryForm />
          </DefaultLayout>
        }
      />
      <Route
        path="/country"
        element={
          <DefaultLayout>
            <PageTitle title="Country" />
            <CountryList/>
          </DefaultLayout>
        }
      />
      <Route
      path="/cityform"
      element={
        <DefaultLayout>
          <PageTitle title="City Form" />
          <CityForm/>
        </DefaultLayout>
      }
    />
    <Route
      path="/city"
      element={
        <DefaultLayout>
          <PageTitle title="City" />
          <CityList/>
        </DefaultLayout>
      }
    />
      <Route
      path="/areaform"
      element={
        <DefaultLayout>
          <PageTitle title="Area Form" />
          <AreaForm/>
        </DefaultLayout>
      }
    />
    <Route
      path="/area"
      element={
        <DefaultLayout>
          <PageTitle title="Area" />
          <AreaList/>
        </DefaultLayout>
      }
    />
      <Route
      path="/addressform"
      element={
        <DefaultLayout>
          <PageTitle title="Address Form" />
          <AddressForm/>
        </DefaultLayout>
      }
    />
    <Route
      path="/address"
      element={
        <DefaultLayout>
          <PageTitle title="Address" />
          <AddressList/>
        </DefaultLayout>
      }
    />
      <Route
      
        path="/forms/form-elements"
        element={
          <DefaultLayout>
            <PageTitle title="Form Elements | TailAdmin - Tailwind CSS Admin Dashboard Template" />
            <FormElements />
          </DefaultLayout>
        }
      />
      <Route
        path="/forms/form-layout"
        element={
          <DefaultLayout>
            <PageTitle title="Form Layout | TailAdmin - Tailwind CSS Admin Dashboard Template" />
            <FormLayout />
          </DefaultLayout>
        }
      />
      <Route
        path="/tables"
        element={ 
          <DefaultLayout>
            <PageTitle title="Tables | TailAdmin - Tailwind CSS Admin Dashboard Template" />
            <Tables />
          </DefaultLayout>
        }
      />
      <Route
        path="/settings"
        element={
          <DefaultLayout>
            <PageTitle title="Settings | TailAdmin - Tailwind CSS Admin Dashboard Template" />
            <Settings />
          </DefaultLayout>
        }
      />
      <Route
        path="/chart"
        element={
          <DefaultLayout>
            <PageTitle title="Basic Chart | TailAdmin - Tailwind CSS Admin Dashboard Template" />
            <Chart />
          </DefaultLayout>
        }
      />
      <Route
        path="/ui/alerts"
        element={
          <DefaultLayout>
            <PageTitle title="Alerts | TailAdmin - Tailwind CSS Admin Dashboard Template" />
            <Alerts />
          </DefaultLayout>
        }
      />
      <Route
        path="/ui/buttons"
        element={
          <DefaultLayout>
            <PageTitle title="Buttons | TailAdmin - Tailwind CSS Admin Dashboard Template" />
            <Buttons />
          </DefaultLayout>
        }
      />
    </Routes>
  );
}

export default App;
