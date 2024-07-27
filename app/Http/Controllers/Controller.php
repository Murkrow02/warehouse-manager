<?php

namespace App\Http\Controllers;

use App\Exceptions\InvalidStoreException;
use App\Models\Store;

abstract class Controller
{
    /**
     * @throws InvalidStoreException
     */
    protected function getStoreIdOrThrow() : int
    {
        // Get store id from header
        $storeId = request()->header('store_id');

        // If store id is not provided, throw an exception
        if (!$storeId) {
            throw new InvalidStoreException();
        }

        return $storeId;
    }

    /**
     * @throws InvalidStoreException
     */
    protected function getStoreOrThrow()
    {
        // Get store id from query string
        $storeId = $this->getStoreIdOrThrow();

        // Get store from database
        $store = Store::find($storeId);

        // If store is not found, throw an exception
        if (!$store) {
            throw new InvalidStoreException();
        }

        return $store;
    }
}
