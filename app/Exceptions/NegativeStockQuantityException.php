<?php

namespace App\Exceptions;

use App\Models\Stock;
use Exception;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Throwable;

class NegativeStockQuantityException extends Exception
{
    public function __construct(
        protected Stock $stock,
        string $message = "", int $code = 0, ?Throwable $previous = null)
    {
        parent::__construct("Cannot decrement stock below 0 for item {$stock->item->name} in warehouse {$stock->warehouse->name}", $code, $previous);
    }

    /**
     * Render the exception as an HTTP response.
     */
    public function render(Request $request): Response
    {

    }
}
