import { useEffect, useState } from 'react';
import { Route, Routes, useLocation } from 'react-router-dom';

import Loader from './common/Loader';
import PageTitle from './components/PageTitle';
import SignIn from './pages/Authentication/SignIn';
import SignUp from './pages/Authentication/SignUp';

import Chart from './pages/Chart';
import FormElements from './pages/Form/FormElements';
import FormLayout from './pages/Form/FormLayout';
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

import PerkList from './pages/Perks/PerkList';
import PerkTypeList from './pages/Perks/PerkTypeList';
import PerkForm from './pages/Perks/PerkForm';
import PerkTypeForm from './pages/Perks/PerkTypeForm';

import UserForm from './pages/Users/UserForm';
import UserList from './pages/Users/UserList';
import MenuForm from './pages/Menus/MenuForm';
import MenuList from './pages/Menus/MenuList';

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
            <PageTitle title="Signin | PerkUP " />
            <SignIn />
          </>
        }
      />
      <Route
        path="/auth/signup"
        element={
          <>
            <PageTitle title="Signup | PerkUP " />
            <SignUp />
          </>
        }
      />

      {/* Dashboard Routes */}
   
        <Route
        path="/perktypeform/:id"
        element={
          <DefaultLayout>
            <PageTitle title="Perk Type Form" />
            <PerkTypeForm />
          </DefaultLayout>
        }
      />
        <Route
        path="/perkform/:id"
        element={
          <DefaultLayout>
            <PageTitle title="Perk Form" />
            <PerkForm />
          </DefaultLayout>
        }
      />
          <Route
        path="/perktypeform"
        element={
          <DefaultLayout>
            <PageTitle title="Perk Type Form" />
            <PerkTypeForm />
          </DefaultLayout>
        }
      />
        <Route
        path="/perkform"
        element={
          <DefaultLayout>
            <PageTitle title="Perk Form" />
            <PerkForm />
          </DefaultLayout>
        }
      />
      <Route
        path="/perktype"
        element={
          <DefaultLayout>
            <PageTitle title="Perk Type List" />
            <PerkTypeList />
          </DefaultLayout>
        }
      />
      <Route
        path="/perk"
        element={
          <DefaultLayout>
            <PageTitle title="Perk List" />
            <PerkList />
          </DefaultLayout>
        }
      />
        <Route
        path="/menu"
        element={
          <DefaultLayout>
            <PageTitle title="Menu List" />
            <MenuList />
          </DefaultLayout>
        }
      />
         <Route
        path="/menuform/:id"
        element={
          <DefaultLayout>
            <PageTitle title="Menu Form" />
            <MenuForm />
          </DefaultLayout>
        }
      />
          <Route
        path="/menuform"
        element={
          <DefaultLayout>
            <PageTitle title="Menu Form" />
            <MenuForm />
          </DefaultLayout>
        }
      />
       <Route
        path="/countryform/:id"
        element={
          <DefaultLayout>
            <PageTitle title="Country Form" />
            <CountryForm />
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
      path="/cityform/:id"
      element={
        <DefaultLayout>
          <PageTitle title="City Form" />
          <CityForm/>
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
      path="/areaform/:id"
      element={
        <DefaultLayout>
          <PageTitle title="Area Form" />
          <AreaForm/>
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
      path="/addressform/:id"
      element={
        <DefaultLayout>
          <PageTitle title="Address Form" />
          <AddressForm/>
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
      path="/user"
      element={
        <DefaultLayout>
          <PageTitle title="User" />
          <UserList/>
        </DefaultLayout>
      }
    />
         <Route
      path="/userform/:id"
      element={
        <DefaultLayout>
          <PageTitle title="User" />
          <UserForm/>
        </DefaultLayout>
      }
    />
         <Route
      path="/userform"
      element={
        <DefaultLayout>
          <PageTitle title="User" />
          <UserForm/>
        </DefaultLayout>
      }
    />
      <Route
      
        path="/forms/form-elements"
        element={
          <DefaultLayout>
            <PageTitle title="Form Elements | PerkUP " />
            <FormElements />
          </DefaultLayout>
        }
      />
      <Route
        path="/forms/form-layout"
        element={
          <DefaultLayout>
            <PageTitle title="Form Layout | PerkUP " />
            <FormLayout />
          </DefaultLayout>
        }
      />
      <Route
        path="/tables"
        element={ 
          <DefaultLayout>
            <PageTitle title="Tables | PerkUP " />
            <Tables />
          </DefaultLayout>
        }
      />
      <Route
        path="/settings"
        element={
          <DefaultLayout>
            <PageTitle title="Settings | PerkUP " />
            <Settings />
          </DefaultLayout>
        }
      />
      <Route
        path="/chart"
        element={
          <DefaultLayout>
            <PageTitle title="Basic Chart | PerkUP " />
            <Chart />
          </DefaultLayout>
        }
      />
      <Route
        path="/ui/alerts"
        element={
          <DefaultLayout>
            <PageTitle title="Alerts | PerkUP " />
            <Alerts />
          </DefaultLayout>
        }
      />
      <Route
        path="/ui/buttons"
        element={
          <DefaultLayout>
            <PageTitle title="Buttons | PerkUP " />
            <Buttons />
          </DefaultLayout>
        }
      />
    </Routes>
  );
}

export default App;
