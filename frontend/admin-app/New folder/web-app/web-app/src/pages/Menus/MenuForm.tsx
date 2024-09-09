import React, { useState, useEffect } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import api from '../../api'; // Adjust the import according to your project structure

interface MenuItem {
    menuItemID: number;
    menuID: number;
    itemName: string;
    description?: string;
    image?: string;
    price: number;
    discount: number;
    isPercentageDiscount: boolean;
    isActive: boolean;
    category: string;
    createdBy: number;
    createdAt: string;
    updatedBy: number;
    updatedAt: string;
}

interface Menu {
    menuID: number;
    menuName: string;
    description?: string;
    image?: string;
    isActive: boolean;
    createdBy: number;
    createdAt: string;
    updatedBy: number;
    updatedAt: string;
    menuItems: MenuItem[];
}

const initialMenuData: Partial<Menu> = {
    menuID: 0,
    menuName: '',
    description: '',
    image: '',
    isActive: true,
    createdBy: 0,
    createdAt: new Date().toISOString(),
    updatedBy: 0,
    updatedAt: new Date().toISOString(),
    menuItems: []
};

const MenuForm = () => {
    const { id } = useParams();
    const [menu, setMenu] = useState<Partial<Menu>>(initialMenuData);
    const [alert, setAlert] = useState<{ type: 'success' | 'error'; message: string } | null>(null);
    const [loading, setLoading] = useState<boolean>(true);
    const navigate = useNavigate();

    useEffect(() => {
        const fetchMenu = async () => {
            if (id !== null && id !== undefined) {
                try {
                    const response = await api.get(`/Menus/${id}`);
                    setMenu(response.data);
                } catch (error) {
                    console.error('Error fetching menu data:', error);
                    setAlert({ type: 'error', message: 'Failed to load menu data' });
                } finally {
                    setLoading(false);
                }
            } else {
                setMenu(initialMenuData);
                setLoading(false);
            }
        };

        fetchMenu();
    }, [id]);

    const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
        const { name, value } = e.target;
        setMenu({
            ...menu,
            [name]: value
        });
    };

    const handleMenuItemChange = (index: number, field: string, value: any) => {
        const updatedMenuItems = [...(menu.menuItems || [])];
        updatedMenuItems[index] = {
            ...updatedMenuItems[index],
            [field]: value
        };
        setMenu({ ...menu, menuItems: updatedMenuItems });
    };

    const addMenuItem = () => {
        setMenu({
            ...menu,
            menuItems: [
                ...(menu.menuItems || []),
                {
                    menuItemID: 0,
                    menuID: menu.menuID || 0,
                    itemName: '',
                    description: '',
                    image: '',
                    price: 0,
                    discount: 0,
                    isPercentageDiscount: true,
                    isActive: true,
                    category: '',
                    createdBy: 0,
                    createdAt: new Date().toISOString(),
                    updatedBy: 0,
                    updatedAt: new Date().toISOString()
                }
            ]
        });
    };

    const removeMenuItem = (index: number) => {
        const updatedMenuItems = [...(menu.menuItems || [])];
        updatedMenuItems.splice(index, 1);
        setMenu({ ...menu, menuItems: updatedMenuItems });
    };

    const handleSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
        e.preventDefault();
        try {
            if (id !== null && id !== undefined) {
                await api.put(`/Menus/${id}`, menu);
                setAlert({ type: 'success', message: 'Menu updated successfully!' });
            } else {
                const response = await api.post('/Menus', menu);
                setMenu(response.data);
                setAlert({ type: 'success', message: 'Menu created successfully!' });
            }
            navigate('/menu'); // Redirect after success
        } catch (error) {
            console.error('Error saving menu:', error);
            setAlert({ type: 'error', message: 'Failed to save menu' });
        }
    };

    const handleBackClick = () => {
        navigate('/menu');
    };

    if (loading) return <div>Loading...</div>;

    return (
        <div className="rounded-sm border border-stroke bg-white shadow-default dark:border-strokedark dark:bg-boxdark">
            <div className="border-b border-stroke py-4 px-6.5 dark:border-strokedark flex justify-between items-center">
                <h3 className="font-medium text-black dark:text-white">
                    {id ? 'Update Menu' : 'Create Menu'}
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
                    <label htmlFor="menuName" className="mb-3 block text-black dark:text-white">
                        Menu Name
                    </label>
                    <input
                        type="text"
                        id="menuName"
                        name="menuName"
                        value={menu.menuName || ''}
                        onChange={handleChange}
                        required
                        className="w-full rounded-lg border-[1.5px] border-stroke bg-transparent py-3 px-5 text-black outline-none transition focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter dark:border-form-strokedark dark:bg-form-input dark:text-white dark:focus:border-primary"
                    />
                </div>
                <div>
                    <label htmlFor="description" className="mb-3 block text-black dark:text-white">
                        Description
                    </label>
                    <input
                        type="text"
                        id="description"
                        name="description"
                        value={menu.description || ''}
                        onChange={handleChange}
                        className="w-full rounded-lg border-[1.5px] border-stroke bg-transparent py-3 px-5 text-black outline-none transition focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter dark:border-form-strokedark dark:bg-form-input dark:text-white dark:focus:border-primary"
                    />
                </div>
                <div>
                    <label htmlFor="image" className="mb-3 block text-black dark:text-white">
                        Image
                    </label>
                    <input
                        type="text"
                        id="image"
                        name="image"
                        value={menu.image || ''}
                        onChange={handleChange}
                        className="w-full rounded-lg border-[1.5px] border-stroke bg-transparent py-3 px-5 text-black outline-none transition focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter dark:border-form-strokedark dark:bg-form-input dark:text-white dark:focus:border-primary"
                    />
                </div>
                <div>
                    <label htmlFor="isActive" className="mb-3 block text-black dark:text-white">
                        Is Active
                    </label>
                    <input
                        type="checkbox"
                        id="isActive"
                        name="isActive"
                        checked={menu.isActive || false}
                        onChange={(e) => setMenu({ ...menu, isActive: e.target.checked })}
                        className="w-full rounded-lg border-[1.5px] border-stroke bg-transparent py-3 px-5 text-black outline-none transition focus:border-primary active:border-primary disabled:cursor-default disabled:bg-whiter dark:border-form-strokedark dark:bg-form-input dark:text-white dark:focus:border-primary"
                    />
                </div>
                <div>
                    <h2>Menu Items</h2>
                    <table className="w-full border-collapse border border-stroke">
                        <thead>
                            <tr>
                                <th className="border border-stroke py-2 px-4">Item Name</th>
                                <th className="border border-stroke py-2 px-4">Description</th>
                                <th className="border border-stroke py-2 px-4">Price</th>
                                <th className="border border-stroke py-2 px-4">Discount</th>
                                <th className="border border-stroke py-2 px-4">Category</th>
                                <th className="border border-stroke py-2 px-4">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            {menu.menuItems?.map((item, index) => (
                                <tr key={item.menuItemID}>
                                    <td className="border border-stroke py-2 px-4">
                                        <input
                                            type="text"
                                            value={item.itemName}
                                            onChange={(e) => handleMenuItemChange(index, 'itemName', e.target.value)}
                                            className="w-full border-none bg-transparent py-1 px-2"
                                        />
                                    </td>
                                    <td className="border border-stroke py-2 px-4">
                                        <input
                                            type="text"
                                            value={item.description || ''}
                                            onChange={(e) => handleMenuItemChange(index, 'description', e.target.value)}
                                            className="w-full border-none bg-transparent py-1 px-2"
                                        />
                                    </td>
                                    <td className="border border-stroke py-2 px-4">
                                        <input
                                            type="number"
                                            value={item.price}
                                            onChange={(e) => handleMenuItemChange(index, 'price', parseFloat(e.target.value))}
                                            className="w-full border-none bg-transparent py-1 px-2"
                                        />
                                    </td>
                                    <td className="border border-stroke py-2 px-4">
                                        <input
                                            type="number"
                                            value={item.discount}
                                            onChange={(e) => handleMenuItemChange(index, 'discount', parseFloat(e.target.value))}
                                            className="w-full border-none bg-transparent py-1 px-2"
                                        />
                                    </td>
                                    <td className="border border-stroke py-2 px-4">
                                        <input
                                            type="text"
                                            value={item.category}
                                            onChange={(e) => handleMenuItemChange(index, 'category', e.target.value)}
                                            className="w-full border-none bg-transparent py-1 px-2"
                                        />
                                    </td>
                                    <td className="border border-stroke py-2 px-4">
                                        <button
                                            type="button"
                                            onClick={() => removeMenuItem(index)}
                                            className="text-red-600 hover:underline"
                                        >
                                            Remove
                                        </button>
                                    </td>
                                </tr>
                            ))}
                        </tbody>
                    </table>
                    <button
                        type="button"
                        onClick={addMenuItem}
                        className="mt-4 bg-primary text-white py-2 px-4 rounded-lg hover:bg-opacity-90"
                    >
                        Add Menu Item
                    </button>
                </div>
                <div className="flex gap-4 mt-4">
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
                        {id ? 'Update Menu' : 'Create Menu'}
                    </button>
                </div>
            </form>
        </div>
    );
};

export default MenuForm;
