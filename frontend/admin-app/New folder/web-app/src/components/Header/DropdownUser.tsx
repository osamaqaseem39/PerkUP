import {  useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import ClickOutside from '../ClickOutside';
import UserOne from '../../images/user/user-01.png';
import { useAuth } from '../AuthContext'; // Ensure this path is correct



const DropdownUser = () => {
  
  const  displayName  = localStorage.getItem('display-name');
  const [dropdownOpen, setDropdownOpen] = useState(false);
  const { dispatch } = useAuth();
  const navigate = useNavigate(); // Updated to useNavigate for consistency
  
  const handleLogout = () => {
    // Dispatch the LOGOUT action
    dispatch({ type: 'LOGOUT' });

    // Clear any stored authentication tokens
    localStorage.removeItem('accessToken');

    // Redirect to the login or home page
    navigate('/');
  };

  return (
    <ClickOutside onClick={() => setDropdownOpen(false)} className="relative">
      <Link
        onClick={() => setDropdownOpen(!dropdownOpen)}
        className="flex items-center gap-4"
        to="#"
      >
       <span className="hidden text-right lg:block">
  <span className="block text-sm font-medium text-black dark:text-white">
    {displayName || 'Guest'} {/* Fallback to 'Guest' if displayName is not available */}
  </span>
 
</span>

        <span className="h-12 w-12 rounded-full">
          <img src={UserOne} alt="User" />
        </span>

        <svg
          className="hidden fill-current sm:block"
          width="12"
          height="8"
          viewBox="0 0 12 8"
          xmlns="http://www.w3.org/2000/svg"
        >
          <path
            fillRule="evenodd"
            clipRule="evenodd"
            d="M0.410765 0.910734C0.736202 0.585297 1.26384 0.585297 1.58928 0.910734L6.00002 5.32148L10.4108 0.910734C10.7362 0.585297 11.2638 0.585297 11.5893 0.910734C11.9147 1.23617 11.9147 1.76381 11.5893 2.08924L6.58928 7.08924C6.26384 7.41468 5.7362 7.41468 5.41077 7.08924L0.410765 2.08924C0.0853277 1.76381 0.0853277 1.23617 0.410765 0.910734Z"
          />
        </svg>
      </Link>

      {/* Dropdown Menu */}
      {dropdownOpen && (
        <div className="absolute right-0 mt-4 flex w-62.5 flex-col rounded-sm border border-stroke bg-white shadow-default dark:border-strokedark dark:bg-boxdark">
          
          <button
            onClick={handleLogout}
            className="flex items-center gap-3.5 px-6 py-4 text-sm font-medium text-meta-3 duration-300 ease-in-out hover:text-primary lg:text-base"
          >
            {/* SVG for Logout */}
            <svg
              className="fill-current"
              width="22"
              height="22"
              viewBox="0 0 22 22"
              xmlns="http://www.w3.org/2000/svg"
            >
              {/* SVG Paths */}
              <path
                d="M12.1937 21.4156H6.59685C5.7531 21.4156 5.0031 21.0719 4.4906 20.5594C3.9781 20.0469 3.63435 19.3312 3.63435 18.4875V15.8406C3.63435 15.3937 3.9781 15.05 4.42498 15.05C4.87185 15.05 5.2156 15.3937 5.2156 15.8406V18.4875C5.2156 18.8531 5.3781 19.1781 5.59685 19.3969C5.8156 19.6156 6.1406 19.7781 6.50623 19.7781H12.1031C12.4687 19.7781 12.7937 19.6156 13.0125 19.3969C13.2312 19.1781 13.3937 18.8531 13.3937 18.4875V3.51249C13.3937 3.14687 13.2312 2.82187 13.0125 2.60312C12.7937 2.38437 12.4687 2.22187 12.1031 2.22187H6.50623C6.1406 2.22187 5.8156 2.38437 5.59685 2.60312C5.3781 2.82187 5.2156 3.14687 5.2156 3.51249V6.15937C5.2156 6.60624 4.87185 6.94999 4.42498 6.94999C3.9781 6.94999 3.63435 6.60624 3.63435 6.15937V3.51249C3.63435 2.66874 3.9781 1.95312 4.4906 1.44062C5.0031 0.928119 5.71873 0.584366 6.59685 0.584366H12.1937C13.0406 0.584366 13.7562 0.928119 14.2687 1.44062C14.7812 1.95312 15.125 2.66874 15.125 3.51249V18.4875C15.125 19.3312 14.7812 20.0469 14.2687 20.5594C13.7562 21.0719 13.0406 21.4156 12.1937 21.4156Z"
              />
              <path
                d="M21.3031 10.4437L18.7187 7.85937C18.4156 7.55624 17.9281 7.55624 17.625 7.85937C17.3219 8.16249 17.3219 8.64999 17.625 8.95312L19.35 10.6781H8.6781C8.23123 10.6781 7.88748 11.0219 7.88748 11.4687C7.88748 11.9156 8.23123 12.2594 8.6781 12.2594H19.35L17.625 13.9844C17.3219 14.2875 17.3219 14.775 17.625 15.0781C17.9281 15.3812 18.4156 15.3812 18.7187 15.0781L21.3031 12.4937C21.6156 12.1906 21.6156 11.7031 21.3031 11.4V10.4437Z"
              />
            </svg>
            Log Out
          </button>
        </div>
      )}
    </ClickOutside>
  );
};

export default DropdownUser;
