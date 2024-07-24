<?php

namespace App\Http\Controllers;

use App\Models\Message;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;

class MessageController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $messages = Message::where('receiver_store_id', $this->getStoreIdOrThrow())
            ->orWhere('sender_store_id', $this->getStoreIdOrThrow())
            ->paginate(10);

        return response()->json($messages);
    }

    public function show(Message $message): JsonResponse
    {
        return response()->json($message);
    }

    public function store(Request $request): JsonResponse
    {
        $request->validate([
            'receiver_store_id' => 'required|exists:stores,id',
            'text' => 'required|string',
            'status' => 'required|string',
        ]);

        $message = Message::create([
            'sender_store_id' => $this->getStoreIdOrThrow(),
            'receiver_store_id' => $request->input('receiver_store_id'),
            'text' => $request->input('text'),
            'status' => $request->input('status'),
        ]);

        return response()->json($message, 201);
    }

    public function update(Request $request, Message $message): JsonResponse
    {
        $request->validate([
            'status' => 'string',
        ]);

        $message->update($request->all());

        return response()->json($message);
    }

    public function destroy(Message $message): JsonResponse
    {
        $message->delete();

        return response()->json(null, 204);
    }
}
