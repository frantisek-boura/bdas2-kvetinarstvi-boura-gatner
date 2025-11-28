import React from 'react';

const CategoryItem = ({ category, level, filterHandler }) => {
    const hasChildren = category.children && category.children.length > 0;

    const paddingClass = level > 0 ? `ps-${level * 3}` : '';

    const itemClass = level === 0
        ? "list-group-item list-group-item-action fw-bold"
        : "list-group-item list-group-item-action";

    return (
        <>
            <li 
                onClick={() => filterHandler(category.id_kategorie)}
                key={category.id_kategorie}
                className={`${itemClass} ${paddingClass}`}
            >
                {'='.repeat((level)) + ' ' + category.nazev}
            </li>

            {hasChildren && (
                <>
                    {category.children.map((child) => (
                        <CategoryItem
                            key={child.id_kategorie}
                            category={child}
                            level={level + 1}
                            filterHandler={filterHandler}
                        />
                    ))}
                </>
            )}
        </>
    );
};

export default CategoryItem;