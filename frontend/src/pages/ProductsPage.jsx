import React from 'react'
import Categories from '../components/Categories'

export default function ProductsPage() {
    return (
        <div className='d-flex flex-row justify-content-start w-75 m-5'>
            <Categories />
            <h1>Products</h1>
        </div>
    )
}
