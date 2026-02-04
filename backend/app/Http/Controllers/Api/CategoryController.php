<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Category;
use Illuminate\Http\Request;

class CategoryController extends Controller
{
    public function index(Request $request)
    {
        return $request->user()->categories;
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string',
            'type' => 'required|string|in:income,expense',
        ]);

        $category = $request->user()->categories()->create($validated);

        return response()->json($category, 201);
    }

    public function show(Request $request, Category $category)
    {
        if ($request->user()->id !== $category->user_id) {
            abort(403);
        }
        return $category;
    }

    public function update(Request $request, Category $category)
    {
        if ($request->user()->id !== $category->user_id) {
            abort(403);
        }

        $validated = $request->validate([
            'name' => 'sometimes|required|string',
            'type' => 'sometimes|required|string|in:income,expense',
        ]);

        $category->update($validated);

        return $category;
    }

    public function destroy(Request $request, Category $category)
    {
        if ($request->user()->id !== $category->user_id) {
            abort(403);
        }

        $category->delete();

        return response()->noContent();
    }
}
